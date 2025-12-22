import os
import subprocess
import threading
import eventlet
import re
import json
from flask import Flask, send_from_directory
from flask_socketio import SocketIO, emit

# Force eventlet for async performance
eventlet.monkey_patch()

# Set base directory to the project root (e:\OpenAI mapped to /mnt/e/OpenAI)
BASE_DIR = "/mnt/e/OpenAI"
app = Flask(__name__, static_folder=BASE_DIR)
socketio = SocketIO(app, cors_allowed_origins="*")

# State management
simulation_process = None
is_running = False

# Regex for parsing reward logs: Reward: [-14. -14.  14.  14.]
reward_pattern = re.compile(r"Reward:\s*\[\s*([\d\.\-\s]+)\]")

# --- WEB ROUTES ---
@app.route('/')
def index():
    return send_from_directory(BASE_DIR, 'index.html')

@app.route('/<path:path>')
def static_proxy(path):
    return send_from_directory(BASE_DIR, path)

# --- SIMULATION LOGIC ---
def parse_rewards(line):
    match = reward_pattern.search(line)
    if match:
        try:
            vals = [float(v) for v in match.group(1).split() if v.strip()]
            if len(vals) >= 4:
                hider_avg = (vals[0] + vals[1]) / 2
                seeker_avg = (vals[2] + vals[3]) / 2
                return {"hider": round(hider_avg, 2), "seeker": round(seeker_avg, 2)}
        except Exception as e:
            print(f"Error parsing reward: {e}")
    return None

def simulation_worker():
    global simulation_process, is_running
    
    env = os.environ.copy()
    env["MUJOCO_GL"] = "egl"
    env["LD_LIBRARY_PATH"] = "/root/.mujoco/mujoco210/bin:/usr/lib/wsl/lib:/usr/lib/x86_64-linux-gnu:" + env.get("LD_LIBRARY_PATH", "")
    env["PYTHONPATH"] = "/mnt/e/OpenAI/multi-agent-emergence-environments:" + env.get("PYTHONPATH", "")

    cwd = "/mnt/e/OpenAI/multi-agent-emergence-environments"
    cmd = [
        "python", "bin/examine.py", 
        "examples/hide_and_seek_quadrant.jsonnet", 
        "examples/hide_and_seek_quadrant.npz"
    ]

    try:
        simulation_process = subprocess.Popen(
            cmd, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.STDOUT, 
            text=True, 
            bufsize=1,
            cwd=cwd,
            env=env
        )
        
        for line in iter(simulation_process.stdout.readline, ""):
            line = line.strip()
            if not line: continue
            socketio.emit('log_data', {'msg': line})
            metrics = parse_rewards(line)
            if metrics:
                socketio.emit('metrics_data', metrics)
                
        simulation_process.stdout.close()
        simulation_process.wait()
    except Exception as e:
        socketio.emit('log_data', {'msg': f"CRITICAL ERROR: {str(e)}"})
    finally:
        is_running = False
        socketio.emit('sim_status', {'running': False})

# --- SOCKET EVENTS ---
@socketio.on('connect')
def handle_connect():
    print("Dashboard Connected")
    socketio.emit('sim_status', {'running': is_running})

@socketio.on('toggle_sim')
def handle_toggle(data):
    global simulation_process, is_running
    print(f"Received toggle_sim: {data}")
    
    if data['action'] == 'start' and not is_running:
        is_running = True
        socketio.emit('sim_status', {'running': True})
        socketio.emit('log_data', {'msg': ">>> SYSTEM: Initializing GPU-accelerated simulation..."})
        thread = threading.Thread(target=simulation_worker)
        thread.daemon = True
        thread.start()
    
    elif data['action'] == 'stop' and is_running:
        if simulation_process:
            simulation_process.terminate()
            socketio.emit('log_data', {'msg': ">>> SYSTEM: Simulation terminated by user."})
        is_running = False
        socketio.emit('sim_status', {'running': False})

if __name__ == '__main__':
    print("OpenAI Intelligence Dashboard Server Active")
    print("Access locally at: http://localhost:5000")
    socketio.run(app, host='0.0.0.0', port=5000)
