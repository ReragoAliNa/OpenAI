# OpenAI Hide and Seek Reproduction

This project is a high-fidelity reproduction of the OpenAI Hide and Seek experiment, optimized for **WSL2** (Ubuntu) and **Windows** environments.

## 🚀 Quick Start (WSL2)

If you have WSL2 set up, run the following:
```bash
# 1. Automatic installation of dependencies
bash scripts/wsl_setup.sh

# 2. Run the simulation
bash scripts/wsl_run.sh
```

---

## 🛠 Prerequisites & Required Software

To run this project successfully, you need the following software installed:

### 1. Core Environment
- **WSL2 (Windows Subsystem for Linux)**: Recommended Ubuntu 20.04 or 22.04.
- **Python 3.7**: Required for TensorFlow 1.15.0 and `baselines` compatibility.
- **MuJoCo 2.1.0**: The physics engine. Download the Linux version for WSL2 or Windows version for native.

### 2. Visualization (Critical for GUI)
- **VcXsrv Windows X Server**: Required to display the MuJoCo simulation window from WSL2 to Windows.
  - [Download VcXsrv](https://sourceforge.net/projects/vcxsrv/)
  - **Launch settings**: 
    - `Multiple windows`
    - `Display number: 0`
    - `Start no client`
    - **Check** `Disable access control` (extremely important)

---

## ⚙️ Configuration & Environment Variables

### WSL2 Configuration
The following environment variables are automatically managed by `scripts/wsl_run.sh`:
- `LD_LIBRARY_PATH`: Includes `~/.mujoco/mujoco210/bin`.
- `DISPLAY`: Set to your Windows Host IP (e.g., `172.x.x.x:0.0`).
- `MUJOCO_GL`: Set to `glfw` or `egl`.
- `LD_PRELOAD`: Preloads `/usr/lib/x86_64-linux-gnu/libGLEW.so` to fix common WSL2 OpenGL issues.

### Python Environment
- **TensorFlow**: `1.15.0`
- **Gym**: `0.10.8`
- **MuJoCo-py**: `2.1.2.14` (Compatible with MuJoCo 210)

---

## 📂 Project Structure

- `docs/`: Guides and reports.
  - `WSL2运行指南.md`: Comprehensive WSL2 setup and troubleshooting.
  - `安装指南.md`: Windows/Conda specific installation guide.
- `scripts/`: Implementation scripts.
  - `wsl_setup.sh`: Automated dependency installer for WSL2.
  - `wsl_run.sh`: Main launcher for WSL2.
  - `run_experiment.ps1`: PowerShell launcher for Windows Native.
- `mujoco-worldgen/`: OpenAI's procedurally generated world engine.
- `multi-agent-emergence-environments/`: The core Hide and Seek environments.

---

## ❓ Common Issues

- **GLEW initialization error**: This is fixed in `wsl_run.sh` by using `LD_PRELOAD`.
- **Display Connection Refused**: Ensure VcXsrv is running and "Disable access control" is checked.
- **ModuleNotFoundError (mae_envs)**: Run `pip install -e multi-agent-emergence-environments/` to install in editable mode.

