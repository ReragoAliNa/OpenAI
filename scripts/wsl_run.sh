#!/bin/bash
# OpenAI Hide and Seek - 运行脚本

# 设置显示输出
if [ -z "$DISPLAY" ] || [ "$DISPLAY" = ":0" ]; then
    export DISPLAY=:0
else
    export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
fi

# 核心：修复 GLEW initialization error (在 WSLg 环境下非常常见)
# 1. 设置 GL 路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/.mujoco/mujoco210/bin:/usr/lib/x86_64-linux-gnu
# 2. 预加载 GLEW 库 (防止使用 mujoco-py 自带的旧版本)
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so
# 3. 设置 GL 渲染方式
export MUJOCO_GL=glfw
# 4. 强制 OpenGL 版本
export MESA_GL_VERSION_OVERRIDE=3.3

# 激活虚拟环境
source /root/openai_hide_env/bin/activate

# 进入项目目录
cd "/mnt/e/OpenAI/multi-agent-emergence-environments"

# 运行实验
echo "正在启动 OpenAI Hide and Seek 仿真..."
echo "当前 DISPLAY: $DISPLAY"
echo "正在运行: bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz"

python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
