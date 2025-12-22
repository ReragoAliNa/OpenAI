#!/bin/bash
# OpenAI Hide and Seek - 运行脚本

# 设置显示输出
if [ -z "$DISPLAY" ] || [ "$DISPLAY" = ":0" ]; then
    export DISPLAY=:0
else
    export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
fi

# 核心路径配置
# 1. MuJoCo 路径
MUJOCO_PATH="/root/.mujoco/mujoco210/bin"
# 2. WSL2 GPU 驱动路径 (NVIDIA)
WSL_GPU_PATH="/usr/lib/wsl/lib"
# 3. 系统库路径
SYS_GL_PATH="/usr/lib/x86_64-linux-gnu"

export LD_LIBRARY_PATH=$MUJOCO_PATH:$WSL_GPU_PATH:$SYS_GL_PATH:$LD_LIBRARY_PATH

# 渲染配置 (启用 GPU 加速)
# 使用 EGL (MuJoCo 2.1.0 推荐的 Linux GPU 渲染后端)
export MUJOCO_GL=egl
# 预加载系统 GLEW 以防止库冲突
export LD_PRELOAD=$SYS_GL_PATH/libGLEW.so
# 强制开启硬件加速支持
export LIBGL_ALWAYS_INDIRECT=0
# 强制 OpenGL 版本
export MESA_GL_VERSION_OVERRIDE=3.3

# 激活虚拟环境
source /root/openai_hide_env/bin/activate

# 进入项目目录
cd "/mnt/e/OpenAI/multi-agent-emergence-environments"

# 运行实验
echo "正在启动 OpenAI Hide and Seek 仿真 (GPU 加速已开启)..."
echo "当前渲染 Backend: $MUJOCO_GL"
echo "当前 DISPLAY: $DISPLAY"

python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
