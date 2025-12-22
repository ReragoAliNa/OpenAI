# OpenAI Hide and Seek 运行脚本
# 此脚本自动配置环境并启动实验

# 1. 设置 MuJoCo PATH
$env:PATH = "C:\Users\33587\.mujoco\mujoco210\bin;" + $env:PATH

# 2. 使用 ma_env 环境的 Python
$python_path = "D:\Miniconda\envs\ma_env\python.exe"

# 3. 切换到项目目录
Set-Location "e:\新建文件夹\OpenAI-\multi-agent-emergence-environments"

# 4. 运行实验
Write-Host "正在启动 OpenAI Hide and Seek 实验..." -ForegroundColor Green
Write-Host "使用 Python: $python_path" -ForegroundColor Cyan
Write-Host "MuJoCo PATH 已设置" -ForegroundColor Cyan
Write-Host ""

& $python_path bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
