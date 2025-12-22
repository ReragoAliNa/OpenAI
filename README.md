# OpenAI Hide and Seek Reproduction

This project is a high-fidelity reproduction of the OpenAI Hide and Seek experiment, optimized for **WSL2** (Ubuntu) and **Windows** environments. It leverages multi-agent reinforcement learning where agents emerge with complex tool-use behaviors like ramp-blocking and shelter-building.

---

## 🚀 Quick Start (WSL2 - Recommended)

The most reliable way to run this experiment is via WSL2.

```bash
# 1. Automatic installation of dependencies (Python 3.7, TensorFlow 1.15, MuJoCo 2.1.0)
bash scripts/wsl_setup.sh

# 2. Run the pre-trained quadrant environment simulation
bash scripts/wsl_run.sh
```

---

## 🛠 Prerequisites & Requirements

### 1. Core Software
- **OS**: Windows 10/11 with **WSL2** (Ubuntu 20.04/22.04 recommended).
- **Python**: 3.7 (Required for TensorFlow 1.15.0/OpenAI Baselines compatibility).
- **Physics Engine**: **MuJoCo 2.1.0**.
- **Libraries**: TensorFlow 1.15.0, Gym 0.10.8, mujoco-py 2.1.x.

### 2. GUI Visualization (Windows Host)
To see the agents in action, you need an X Server on Windows:
- **Software**: [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/).
- **Crucial Launch Settings**:
    - Select `Multiple windows`
    - Set `Display number` to `0`
    - Select `Start no client`
    - **MUST CHECK** `Disable access control`.

---

## 📖 Setup & Installation Guide

### WSL2 Environment (Detailed)
1. **Update System**: `sudo apt-get update && sudo apt-get install libgl1-mesa-dev libglew-dev libosmesa6-dev patchelf`.
2. **Setup MuJoCo**: Place `mujoco210` in `~/.mujoco/` and export `LD_LIBRARY_PATH`.
3. **Environment**: Use `virtualenv` with Python 3.7.
4. **Install Packages**:
   ```bash
   pip install tensorflow==1.15.0
   pip install -e mujoco-worldgen/
   pip install -e multi-agent-emergence-environments/
   ```

### Windows Native (Legacy/Experimental)
Running natively on Windows is challenging due to TensorFlow 1.15's lack of official support for Python 3.7 on Windows.
- Use Conda: `conda create -n openai_hide_py37 python=3.7`.
- Path Configuration: Ensure `mujoco210\bin` is in your System PATH.
- *Note: If errors persist, please switch to the WSL2 method.*

---

## 🔬 Experiment Analysis & Findings

### Emergent Behaviors Observed
In this reproduction, we verify the stages of multi-agent evolution:
1. **Early Stage**: Random movement and basic chasing.
2. **Tool Use**: Hiders learn to move boxes to block entrances.
3. **Ramp Exploits**: Seekers learn to use ramps to jump over walls.
4. **Advanced Defense**: Hiders learn to steal/move ramps and lock them to neutralize Seeker advantages.

### Technical Resolutions
We solved several critical compatibility issues during the porting:
*   **Assertion Fixes**: Patched `xmltodict` usage in `mujoco-worldgen` where dictionary types caused version-specific crashes.
*   **TensorFlow Tensors**: Fixed crashes where Symbolic Tensors were passed directly to NumPy functions in `ma_policy`.
*   **OpenGL fix**: Handled `GLEW initialization error` in WSL2 using `LD_PRELOAD` of system libraries.

---

## 📂 Project Structure

- `scripts/`: Helper utilities.
  - `wsl_setup.sh`: Automated environment builder.
  - `wsl_run.sh`: Main launcher with X11 forwarding config.
  - `run_experiment.ps1`: Windows PowerShell launcher.
- `mujoco-worldgen/`: Procedural environment generation engine.
- `multi-agent-emergence-environments/`: Core RL environments and pre-trained policies.
- `docs/`: (Archived) Original detailed reports and setup guides.

---

## ❓ FAQ & Troubleshooting

| Issue | Solution |
| :--- | :--- |
| **ModuleNotFoundError: mae_envs** | Run `pip install -e multi-agent-emergence-environments/` |
| **Connection Refused (Display)** | Restart VcXsrv and ensure "Disable access control" is checked. |
| **GLFW error/Black screen** | Ensure `MUJOCO_GL=glfw` and `export DISPLAY` is set correctly in WSL. |
| **TF 1.15 on Win 11** | This combination is unstable; use the provided WSL2 scripts. |

---

## 📜 Credits
Based on the original OpenAI paper: *Emergent Tool Use from Multi-Agent Autocurricula*.
Modified and optimized for modern WSL2 workflows.

