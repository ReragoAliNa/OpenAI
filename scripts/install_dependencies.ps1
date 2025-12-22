# Step 1: 安装 TensorFlow 1.15
Write-Host "=== [1/4] 安装 TensorFlow 1.15.0 ===" -ForegroundColor Cyan
D:\Miniconda\envs\openai_hide_py37\python.exe -m pip install tensorflow==1.15.0

Write-Host ""
Write-Host "=== [2/4] 安装 mujoco-worldgen 依赖 ===" -ForegroundColor Cyan
D:\Miniconda\envs\openai_hide_py37\python.exe -m pip install click xmltodict scipy gym jsonnet numpy-stl mujoco-py

Write-Host ""
Write-Host "=== [3/4] 安装项目包 ===" -ForegroundColor Cyan
Set-Location "e:\新建文件夹\OpenAI-"
D:\Miniconda\envs\openai_hide_py37\python.exe -m pip install -e mujoco-worldgen/

Write-Host ""
Write-Host "=== [4/4] 安装 multi-agent 依赖 ===" -ForegroundColor Cyan
D:\Miniconda\envs\openai_hide_py37\python.exe -m pip install cloudpickle baselines opencv-python pytest
D:\Miniconda\envs\openai_hide_py37\python.exe -m pip install -e multi-agent-emergence-environments/

Write-Host ""
Write-Host "=== ✅ 安装完成！ ===" -ForegroundColor Green
Write-Host ""
Write-Host "现在可以运行项目了！请执行:" -ForegroundColor Yellow
Write-Host "  .\run_with_py37.ps1" -ForegroundColor White
