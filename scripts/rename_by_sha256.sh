#!/usr/bin/env bash

function rename_file() {
	local file="$1"

	if [ ! -f "$file" ]; then
		return 1
	fi

	# Extract directory and filename
	dir=$(dirname "$file")
	filename=$(basename "$file")
	extension="${filename##*.}"
	name="${filename%.*}"

	sha256=$(sha256sum "$file" | cut -d' ' -f1)

	# Preserve extension if it exists
	if [ "$extension" != "$filename" ]; then
		new_name="${sha256}.${extension}"
	else
		new_name="${sha256}"
	fi

	if [ -f "$dir/$new_name" ]; then
		echo "Warning: File '$new_name' already exists, skipping '$filename'"
		return 1
	fi

	mv "$file" "$dir/$new_name"
	echo "Renamed '$filename' to '$new_name'"
	return 0
}

if [ $# -eq 0 ]; then
	echo "Usage: $0 <file_or_directory> [file_or_directory...]"
	echo "If directory is provided, all files in it will be processed"
	exit 1
fi

for target in "$@"; do
	if [ -f "$target" ]; then
		rename_file "$target"
	elif [ -d "$target" ]; then
		echo "Processing directory: $target"
		# Find all files in directory (excluding hidden files)
		while IFS= read -r -d '' file; do
			rename_file "$file"
		done < <(find "$target" -maxdepth 1 -type f -not -name '.*' -print0)
	else
		echo "Warning: '$target' does not exist, skipping"
	fi
done

echo "Batch processing completed"
