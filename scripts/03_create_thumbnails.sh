#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p imagemagick
# shellcheck shell=bash

# Create 200px thumbnails for images in todo/.

for file in todo/*; do
	[[ -f $file && $file != *.preview.* ]] || continue
	name=${file##*/}
	ext=${name##*.}
	case ${ext,,} in
		jpg|jpeg|png|gif|bmp|tiff|webp|svg) ;;
		*) continue ;;
	esac
	thumb=todo/${name%.*}.preview.$ext
	[[ -e $thumb ]] || magick "$file" -resize '200x200>' "$thumb"
done
