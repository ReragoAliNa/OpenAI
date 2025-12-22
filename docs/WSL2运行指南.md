# WSL2 环境下运行 OpenAI Hide and Seek 的完整指南

## 前提条件
确保您已安装 WSL2。如果没有，在 PowerShell（管理员）中运行：
```powershell
wsl --install -d Ubuntu-20.04
```

## 在 WSL2 中运行项目

### 1. 进入 WSL2
```powershell
wsl
```

### 2. 更新系统并安装依赖
```bash
sudo apt-get update
sudo apt-get install -y python3.6 python3.6-dev python3-pip git wget
sudo apt-get install -y libgl1-mesa-dev libgl1-mesa-glx libglew-dev libosmesa6-dev
```

### 3. 安装 MuJoCo 2.1.0
```bash
# 创建目录
mkdir -p ~/.mujoco
cd ~/.mujoco

# 下载 MuJoCo 2.1.0
wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
tar -xzf mujoco210-linux-x86_64.tar.gz

# 设置环境变量
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco210/bin' >> ~/.bashrc
source ~/.bashrc
```

### 4. 创建 Python 虚拟环境
```bash
# 安装 virtualenv
pip3 install virtualenv

# 创建虚拟环境
cd ~
virtualenv -p python3.6 openai_hide_env
source openai_hide_env/bin/activate
```

### 5. 克隆/复制项目
```bash
# 如果项目在 Windows 中，可以访问
cd /mnt/e/OpenAI

# 或者重新克隆
# git clone <repository_url>
```

### 6. 安装依赖
```bash
pip install tensorflow==1.15.0
pip install -r mujoco-worldgen/requirements.txt
pip install -r multi-agent-emergence-environments/requirements_ma_policy.txt
pip install -e mujoco-worldgen/
pip install -e multi-agent-emergence-environments/
```

### 7. 运行实验
```bash
cd multi-agent-emergence-environments
python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
```

## 可视化问题解决

如果遇到显示问题，安装 X server：

### 在 Windows 上：
1. 下载并安装 VcXsrv: https://sourceforge.net/projects/vcxsrv/
2. 启动 XLaunch，选择 "Multiple windows"，Display number: 0
3. 下一步选择 "Start no client"
4. 在 Extra settings 中勾选 "Disable access control"

### 在 WSL2 中：
```bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
export LIBGL_ALWAYS_INDIRECT=1

# 添加到 .bashrc 永久生效
echo 'export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '\''{print $2}'\''):0.0' >> ~/.bashrc
echo 'export LIBGL_ALWAYS_INDIRECT=1' >> ~/.bashrc
```

## 快速启动脚本

创建 `run_experiment.sh`:
```bash
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco210/bin
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
export LIBGL_ALWAYS_INDIRECT=1

cd /mnt/e/OpenAI/multi-agent-emergence-environments
source ~/openai_hide_env/bin/activate
python bin/examine.py examples/hide_and_seek_quadrant.jsonnet examples/hide_and_seek_quadrant.npz
```

赋予执行权限并运行：
```bash
chmod +x run_experiment.sh
./run_experiment.sh
```

## 常见问题

**Q: ImportError: libGL.so.1**
```bash
sudo apt-get install -y libgl1-mesa-glx
```

**Q: 显示窗口无法打开**
- 确保 VcXsrv 正在运行
- 检查 DISPLAY 环境变量
- 尝试运行 `xeyes` 测试 X11 转发

**Q: MuJoCo 许可证问题**
MuJoCo 2.1.0 及以后版本免费，不需要许可证。

## 性能优化

如果运行缓慢，可以：
1. 关闭实时可视化，仅记录结果
2. 使用 headless 模式（修改代码移除可视化部分）
3. 增加 WSL2 的内存限制
