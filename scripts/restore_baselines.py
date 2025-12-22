"""
Restore baselines tf_util.py to original state
"""
import os
import re

tf_util_path = r"D:\Miniconda\envs\ma_env\lib\site-packages\baselines\common\tf_util.py"

print(f"Restoring {tf_util_path}...")

with open(tf_util_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Revert the incorrect changes
content = content.replace('tf.dtypes.float32', 'tf.float32')
content = content.replace('tf.dtypes.float64', 'tf.float64')
content = content.replace('tf.dtypes.int32', 'tf.int32')
content = content.replace('tf.dtypes.int64', 'tf.int64')
content = content.replace('tf.dtypes.bool', 'tf.bool')
content = content.replace('tf.dtypes.uint8', 'tf.uint8')

with open(tf_util_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ Restored tf_util.py")
print("\nTensorFlow 2.12 uses tf.float32 directly, not tf.dtypes.float32")
