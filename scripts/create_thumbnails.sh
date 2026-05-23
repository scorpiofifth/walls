#!/usr/bin/env bash

# 创建图片缩略图脚本
# 用法: ./create_thumbnails.sh [文件名或目录名...]

# 支持的图片文件扩展名
image_extensions=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "webp" "svg")

# 检查是否是图片文件
is_image_file() {
	local file="$1"
	local basename=$(basename "$file")

	# 跳过已经包含 .preview. 的文件
	if [[ "$basename" == *.preview.* ]]; then
		return 1
	fi

	local extension="${file##*.}"
	extension="${extension,,}" # 转换为小写

	for ext in "${image_extensions[@]}"; do
		if [[ "$extension" == "$ext" ]]; then
			return 0
		fi
	done
	return 1
}

# 创建缩略图
create_thumbnail() {
	local file="$1"
	local dir=$(dirname "$file")
	local basename=$(basename "$file")
	local name="${basename%.*}"
	local extension="${basename##*.}"

	# 构建缩略图文件名
	local thumbnail_name="${name}.preview.${extension}"
	local thumbnail_path="${dir}/${thumbnail_name}"

	echo "正在创建缩略图: '$file' -> '$thumbnail_path'"

	# 使用ImageMagick创建缩略图（宽度最大为200px，保持宽高比）
	magick "$file" -resize "200x200>" "$thumbnail_path"

	if [ $? -eq 0 ]; then
		echo "缩略图创建成功: '$thumbnail_path'"
		return 0
	else
		echo "缩略图创建失败: '$file'"
		return 1
	fi
}

# 处理单个文件
process_file() {
	local file="$1"

	if [ ! -f "$file" ]; then
		echo "错误: 文件 '$file' 不存在"
		return
	fi

	if is_image_file "$file"; then
		echo "'$file' 是图片文件"
		create_thumbnail "$file"
	else
		echo "'$file' 不是图片文件，跳过"
	fi
}

# 检查ImageMagick是否安装
if ! command -v magick &>/dev/null; then
	echo "错误: ImageMagick 未安装"
	echo "请先安装 ImageMagick: sudo apt-get install imagemagick"
	exit 1
fi

# 如果没有提供参数，处理当前目录下的所有文件
if [ $# -eq 0 ]; then
	echo "处理当前目录下的所有图片文件..."
	for file in *; do
		if [ -f "$file" ]; then
			process_file "$file"
		fi
	done
else
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
fi
