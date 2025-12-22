# OpenAI Hide and Seek Reproduction

This project is a reproduction of the OpenAI Hide and Seek experiment in WSL2.

## Project Structure

- `docs/`: Documentation and experiment reports.
  - `WSL2运行指南.md`: Instructions for setting up and running in WSL2.
  - `实验报告.md`: Analysis of the experiment results.
  - `安装指南.md`: Basic installation steps.
- `scripts/`: Helper scripts for setup and execution.
  - `wsl_run.sh`: Main script to run the simulation in WSL2.
  - `wsl_setup.sh`: Script to automate dependency installation in WSL2.
  - Various `.ps1` files for Windows/WSL interoperability.
- `mujoco-worldgen/`: Environment generation code.
- `multi-agent-emergence-environments/`: Multi-agent training and testing environments.

## How to Run

1. Ensure WSL2 and MuJoCo are set up (see `docs/WSL2运行指南.md`).
2. Run the simulation using the provided script:
   ```bash
   bash scripts/wsl_run.sh
   ```

## Requirements

- WSL2 (Ubuntu 20.04 or later)
- Python 3.7 (in virtualenv)
- MuJoCo 2.1.0
- TensorFlow 1.15.0
