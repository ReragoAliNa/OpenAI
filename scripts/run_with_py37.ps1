# OpenAI Hide and Seek 运行脚本（使用 Python 3.7 环境）

# 设置 MuJoCo PATH
$env:PATH = "C:\Users\33587\.mujoco\mujoco210\bin;" + $env:PATH

# 使用 Python 3.7 环境
$python_path = "D:\Miniconda\envs\openai_hide_py37\python.exe"

# 切换到项目目录
Set-Location "e:\新建文件夹\OpenAI-\multi-agent-emergence-environments"

Write-Host "=== 启动 OpenAI Hide and Seek 实验 ===" -ForegroundColor Green
Write-Host "Python 环境: $python_path" -ForegroundColor Cyan
Write-Host "MuJoCo PATH 已配置" -ForegroundColor Cyan
Write-Host ""

# 运行实验
& $python_path bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
