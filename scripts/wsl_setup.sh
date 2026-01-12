#!/bin/bash
# OpenAI Hide and Seek - WSL2 自动安装脚本

set -e  # 遇到错误立即退出

echo "======================================"
echo "OpenAI Hide and Seek 自动安装脚本"
echo "======================================"
echo ""

# 1. 更新系统
echo "[1/8] 更新系统包..."
sudo apt-get update -qq
sudo apt-get install -y -qq software-properties-common

# 2. 安装系统依赖
echo "[2/8] 添加 deadsnakes PPA 并安装 Python 3.7..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update -qq
sudo apt-get install -y -qq \
    python3.7 python3.7-dev python3.7-distutils python3.7-venv \
    git wget build-essential \
    libgl1-mesa-dev libgl1 libglew-dev libosmesa6-dev \
    patchelf

# 3. 安装 MuJoCo 2.1.0
echo "[3/8] 安装 MuJoCo 2.1.0..."
mkdir -p ~/.mujoco
cd ~/.mujoco

if [ ! -d "mujoco210" ]; then
    cp "/mnt/e/OpenAI/mujoco210.tar.gz" .
    tar -xzf mujoco210.tar.gz
    rm mujoco210.tar.gz
    echo "✓ MuJoCo 已安装"
else
    echo "✓ MuJoCo 已存在"
fi

# 设置环境变量
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco210/bin

# 4. 创建虚拟环境
echo "[4/8] 创建 Python 3.7 虚拟环境..."
cd ~
if [ ! -d "openai_hide_env" ]; then
    python3.7 -m venv openai_hide_env
fi
source openai_hide_env/bin/activate
echo "✓ 虚拟环境已创建"

# 5. 升级 pip
echo "[5/8] 升级 pip..."
python -m pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip

# 6. 进入项目目录
echo "[6/8] 进入项目目录..."
cd "/mnt/d/OpenAI"

# 7. 安装 Python 依赖
echo "[7/8] 安装 Python 依赖（这可能需要几分钟）..."
pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow==1.15.0
pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple click xmltodict scipy gym==0.10.8 jsonnet numpy-stl mujoco-py
pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple cloudpickle baselines opencv-python pytest
pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple -e mujoco-worldgen/
pip install -q -i https://pypi.tuna.tsinghua.edu.cn/simple -e multi-agent-emergence-environments/

# 8. 完成
echo "[8/8] 安装完成！"
echo ""
echo "======================================"
echo "✓ 环境配置成功！"
echo "======================================"
echo ""
echo "现在可以运行实验："
echo "  cd /mnt/d/OpenAI/multi-agent-emergence-environments"
echo "  python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz"
echo ""
