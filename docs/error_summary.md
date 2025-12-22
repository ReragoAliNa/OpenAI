# OpenAI Hide and Seek 复现错误与解决方案总结

在复现 OpenAI 捉迷藏实验的过程中，我们遇到了涉及环境配置、路径兼容性、代码版本演进等多个层面的问题。以下是核心错误及其解决方案的汇总。

---

## 1. 环境与路径问题

### 1.1 路径硬编码错误 (Path Mismatch)
*   **症状**: 脚本运行报错 `cd: no such file or directory` 或 `File not found`。
*   **原因**: 原始脚本中硬编码了旧的路径（如 `e:\新建文件夹\OpenAI-`），而当前部署路径为 `e:\OpenAI`。
*   **解决方案**: 
    *   全局搜索并替换脚本（`wsl_run.sh`, `wsl_setup.sh`, `run_experiment.ps1`）中的路径。
    *   在 WSL 中使用 `/mnt/e/OpenAI` 访问 Windows 磁盘分区。

### 1.2 模块未安装 (ModuleNotFoundError)
*   **症状**: `ModuleNotFoundError: No module named 'mae_envs'` 或 `mujoco_worldgen`。
*   **原因**: 虚拟环境中未以“可编辑模式”安装本地项目包。
*   **解决方案**: 
    ```bash
    pip install -e mujoco-worldgen/
    pip install -e multi-agent-emergence-environments/
    ```

---

## 2. 源码逻辑兼容性问题 (2019 vs 2024+)

### 2.1 xmltodict 类型断言失败
*   **症状**: `AssertionError` at `mujoco-worldgen` code checking `isinstance(obj, OrderedDict)`.
*   **原因**: 新版本的 `xmltodict` 库默认返回标准 `dict` 而非 `OrderedDict`。
*   **解决方案**: 修改源码中的断言条件，允许 `dict` 类型，或在解析时强制要求返回 `OrderedDict`。

### 2.2 TensorFlow 符号张量与 NumPy 冲突
*   **症状**: `TypeError: Tensor is not an array` 或在 `np.all()`, `np.prod()` 处崩溃。
*   **原因**: 在 `mae_envs` 中，代码尝试将 TF 1.15 的符号张量（Symbolic Tensors）直接传递给 NumPy 函数，这在计算图构建阶段是不允许的。
*   **解决方案**: 将 `np.all()` 替换为 `tf.reduce_all()`，将 `np.prod()` 替换为 `tf.reduce_prod()`，确保操作在计算图内完成。

---

## 3. 图形与渲染问题 (WSL2 特有)

### 3.1 GLEW 初始化错误
*   **症状**: `Missing GL version` 或 `GLEW initialization error`.
*   **原因**: WSL2 环境下，MuJoCo 携带的旧版库与系统现有的 OpenGL 驱动冲突。
*   **解决方案**: 
    *   在 `wsl_run.sh` 中设置 `export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so`。
    *   强制指定渲染后端 `export MUJOCO_GL=glfw`。

### 3.2 无法创建 GLFW 窗口
*   **症状**: `Could not initialize GLFW`。
*   **原因**: 缺少 X Server 转发或环境变量 `DISPLAY` 未正确指向 Windows 宿主机。
*   **解决方案**: 
    *   在宿主机运行 VcXsrv，并勾选 **"Disable access control"**。
    *   在 WSL2 中设置：`export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0`。

---

## 4. 平台架构限制

### 4.1 Windows + Python 3.7 不支持 TF 1.15
*   **症状**: `pip install tensorflow==1.15.0` 找不到匹配版本。
*   **原因**: TensorFlow 1.15 官方未发布适用于 Windows 下 Python 3.7 的安装包。
*   **最终方案**: 放弃在 Windows 原生环境运行，全面迁移至 **WSL2 (Ubuntu)** 环境。

---

## 5. 终端启动问题

### 5.1  Windows 与 Linux 换行符冲突
**症状**:
```
scripts/wsl_run.sh: line 3: $'\r': command not found
scripts/wsl_run.sh: line 43: syntax error: unexpected end of file
```
**原因**: Windows 与 Linux 换行符冲突
**解决方案**:
``
sed -i 's/\r$//' scripts/wsl_run.sh
bash scripts/wsl_run.sh
 ```

---
*日期: 2025-12-23*
