# OpenAI Hide and Seek 完整安装脚本（Python 3.7 环境）
# 此脚本会激活 openai_hide_py37 环境并安装所有依赖

Write-Host "=== OpenAI Hide and Seek 环境配置脚本 ===" -ForegroundColor Cyan
Write-Host ""

# 激活环境
Write-Host "[1/6] 激活 Python 3.7 环境..." -ForegroundColor Green
conda activate openai_hide_py37

# 升级 pip
Write-Host "[2/6] 升级 pip..." -ForegroundColor Green
python -m pip install --upgrade pip

# 安装 TensorFlow 1.15（需要特殊处理）
Write-Host "[3/6] 安装 TensorFlow 1.15.0..." -ForegroundColor Green
pip install tensorflow==1.15.0

# 安装 mujoco-worldgen 依赖
Write-Host "[4/6] 安装 mujoco-worldgen 依赖..." -ForegroundColor Green
Set-Location "e:\新建文件夹\OpenAI-"
# 使用修改后的 requirements.txt（已移除版本限制）
pip install click xmltodict scipy gym jsonnet numpy-stl mujoco-py

# 安装 mujoco-worldgen
Write-Host "[5/6] 安装 mujoco-worldgen..." -ForegroundColor Green
pip install -e mujoco-worldgen/

# 安装 multi-agent-emergence-environments 及其依赖
Write-Host "[6/6] 安装 multi-agent-emergence-environments..." -ForegroundColor Green
pip install cloudpickle baselines opencv-python pytest
pip install -e multi-agent-emergence-environments/

Write-Host ""
Write-Host "=== 安装完成! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：运行实验" -ForegroundColor Yellow
Write-Host "  1. 确保已激活环境: conda activate openai_hide_py37" -ForegroundColor White
Write-Host "  2. 设置 MuJoCo PATH: `$env:PATH = 'C:\Users\33587\.mujoco\mujoco210\bin;' + `$env:PATH" -ForegroundColor White
Write-Host "  3. 运行: cd multi-agent-emergence-environments" -ForegroundColor White
Write-Host "  4. 执行: python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz" -ForegroundColor White
Write-Host ""
