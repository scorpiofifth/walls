#!/usr/bin/env bash

# 图片文件类型判断和转换脚本
# 用法: ./convert_images.sh [-k] [目录名或文件名...]

keep_original=false

# 解析命令行参数
while getopts "k" opt; do
	case $opt in
	k)
		keep_original=true
		shift
		;;
	*)
		echo "用法: $0 [-k] [目录名或文件名...]"
		echo "  -k  保存原始文件，不删除"
		echo "如果不指定目录，则处理当前目录下的所有文件"
		exit 1
		;;
	esac
done

if [ $# -eq 0 ]; then
	echo "用法: $0 [-k] [目录名或文件名...]"
	echo "  -k  保存原始文件，不删除"
	exit 1
fi

# 处理单个文件
process_file() {
	local file="$1"

	if [ ! -f "$file" ]; then
		echo "错误: 文件 '$file' 不存在"
		return
	fi

	# 使用file命令判断文件类型
	file_type=$(file -b "$file")

	# 检查是否为图片文件
	if [[ "$file_type" == *image* ]] || [[ "$file_type" == *JPEG* ]] || [[ "$file_type" == *JPG* ]] || [[ "$file_type" == *PNG* ]] || [[ "$file_type" == *GIF* ]] || [[ "$file_type" == *BMP* ]] || [[ "$file_type" == *TIFF* ]]; then
		echo "'$file' 是图片文件: $file_type"

		# 检查是否为PNG格式
		if [[ "$file_type" != *PNG* ]]; then
			echo "正在转换 '$file' 为PNG格式..."
			output_file="${file%.*}.png"

			# 使用ImageMagick进行转换
			magick "$file" "$output_file"

			if [ $? -eq 0 ]; then
				echo "转换成功: '$file' -> '$output_file'"
				if [ "$keep_original" = false ]; then
					rm "$file"
					echo "已删除原始文件: '$file'"
				else
					echo "保留原始文件: '$file'"
				fi
			else
				echo "转换失败: '$file'"
			fi
		else
			echo "'$file' 已经是PNG格式，无需转换"
		fi
	else
		echo "'$file' 不是图片文件: $file_type"
	fi
}

# 处理所有参数
for target in "$@"; do
	if [ -f "$target" ]; then
		# 处理单个文件
		process_file "$target"
	elif [ -d "$target" ]; then
		# 处理目录下的所有文件
		echo "处理目录: $target"
		find "$target" -type f -print0 | while IFS= read -r -d '' file; do
			process_file "$file"
		done
	else
		echo "错误: '$target' 不是有效的文件或目录"
	fi
done
