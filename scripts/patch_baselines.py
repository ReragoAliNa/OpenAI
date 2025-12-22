"""
Fix baselines compatibility with TensorFlow 2.x
This script patches the baselines library to work with TensorFlow 2.x
"""
import os
import re

baselines_path = r"D:\Miniconda\envs\ma_env\lib\site-packages\baselines"

# Files that need to be patched
files_to_patch = [
    os.path.join(baselines_path, "common", "tf_util.py"),
    os.path.join(baselines_path, "a2c", "utils.py"),
    os.path.join(baselines_path, "ppo2", "model.py"),
]

# Replacement patterns - TensorFlow 2.x keeps tf.float32 etc directly in tf namespace
replacements = [
    # These don't need to be changed in TensorFlow 2.12
    # (r'\btf\.float32\b', 'tf.float32'),
]

def patch_file(filepath):
    """Patch a single file"""
    if not os.path.exists(filepath):
        print(f"Skipping {filepath} - file not found")
        return
    
    print(f"Patching {filepath}...")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content)
    
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  ✓ Patched {filepath}")
    else:
        print(f"  - No changes needed for {filepath}")

if __name__ == "__main__":
    print("Patching baselines for TensorFlow 2.x compatibility...")
    print("=" * 60)
    
    for filepath in files_to_patch:
        try:
            patch_file(filepath)
        except Exception as e:
            print(f"  ✗ Error patching {filepath}: {e}")
    
    print("=" * 60)
    print("Patching complete!")
