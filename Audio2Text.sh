#!/bin/bash

# 检查是否提供了输入目录参数
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

# 获取输入目录的绝对路径
INPUT_DIR=$(realpath "$1")
# 创建输出目录（在输入目录同级，添加_txts后缀）
OUTPUT_DIR="${INPUT_DIR}_txts"

# 检查输入目录是否存在
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory does not exist!"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 处理函数：转换wav文件为txt
process_wav() {
    local wav_file="$1"
    # 获取相对于输入目录的路径
    local rel_path=${wav_file#$INPUT_DIR/}
    # 构建输出文件路径
    local output_path="$OUTPUT_DIR/${rel_path%.wav}.txt"
    # 创建输出文件的目录
    mkdir -p "$(dirname "$output_path")"
    
    echo "Converting: $wav_file"
    echo "Output to: $output_path"
    
    # 执行转换命令
    ./main -m models/ggml-large-v3.bin -otxt true -l zh -f "$wav_file"
    
    # 检查命令是否执行成功
    if [ $? -eq 0 ]; then
        echo "Successfully converted: $wav_file"
    else
        echo "Error converting: $wav_file"
    fi
}

# 递归查找所有wav文件并处理
find "$INPUT_DIR" -type f -name "*.wav" | while read -r wav_file; do
    process_wav "$wav_file"
done

echo "Conversion complete. Results are saved in: $OUTPUT_DIR"
