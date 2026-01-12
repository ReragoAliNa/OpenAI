# OpenAI Hide and Seek Reproduction

This project is a high-fidelity reproduction of the OpenAI Hide and Seek experiment, optimized for **WSL2** (Ubuntu) and **Windows** environments. It leverages multi-agent reinforcement learning where agents emerge with complex tool-use behaviors like ramp-blocking and shelter-building.

---

## 🚀 Quick Start (WSL2 - Recommended)

The most reliable way to run this experiment is via WSL2.

```bash
# 1. Fix line endings (if created on Windows) and run setup
sed -i 's/\r$//' scripts/*.sh
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
   cd mujoco-worldgen && pip install -e .
   cd ../multi-agent-emergence-environments && pip install -e .
   ```

---

## 🔬 Experiment Analysis & Findings

### Emergent Behaviors Observed
In this reproduction, we verify the stages of multi-agent evolution:
1. **Early Stage**: Random movement and basic chasing.
2. **Tool Use**: Hiders learn to move boxes to block entrances.
3. **Ramp Exploits**: Seekers learn to use ramps to jump over walls.
4. **Advanced Defense**: Hiders learn to steal/move ramps and lock them to neutralize Seeker advantages.

## 🎨 Visual Reproduction & Aesthetics

Since January 2026, we have overhauled the rendering pipeline to strictly match the visual style of the original OpenAI "Emergent Tool Use" paper and video.

### Key Visual Updates:
*   **Signature Green Objects**: Changed Boxes and Ramps from generic yellow/beige to the specific **OpenAI Green** (`#38b826` equivalent).
*   **Studio Lighting**:
    *   Replaced top-down lighting with **angled directional sunlight** (`-1 -1 -2`) to illuminate wall faces and create realistic shadows.
    *   Added **Ambient Fill** and **Back Lighting** to prevent pitch-black shadows on walls.
    *   Removed foggy/hazy effects for a crisp, "laboratory" white aesthetic.
*   **High-Contrast Floor**:
    *   Updated floor texture to a high-contrast **Dark/Light Gray Checkerboard**.
    *   Increased texture density to **15x15** (creating a 30x30 grid) to perfectly align visually with the 30x30 logic grid.
    *   Added slight floor **reflectance** for a premium look.
*   **Standardized Geometry**:
    *   Fixed wall heights to **0.5 units** (matching agent height) instead of the previous 4.0 unit "fortress walls".

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
- `mujoco-worldgen/`: Procedural environment generation engine.
- `multi-agent-emergence-environments/`: Core RL environments and pre-trained policies.

---

## ❓ FAQ & Troubleshooting

| Issue | Solution |
| :--- | :--- |
| **TF 1.15 Version Error** | Ensure you are using Python 3.7. |
| **\r command not found** | Run `sed -i 's/\r$//' scripts/*.sh` to fix Windows line endings. |

---

## 📜 Credits
Based on the original OpenAI paper: *Emergent Tool Use from Multi-Agent Autocurricula*.
Modified and optimized for modern WSL2 workflows.

