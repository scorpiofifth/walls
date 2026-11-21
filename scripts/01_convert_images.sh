#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p imagemagick
# shellcheck shell=bash

# Convert images in todo/ to PNG.

for file in todo/*; do
	[[ -f $file ]] || continue
	fmt=$(magick identify -format '%m' "$file" 2>/dev/null) || continue
	[[ $fmt == PNG ]] && continue
	out=${file%.*}.png
	[[ -e $out ]] && continue
	if magick "$file" "$out"; then
		rm -f -- "$file"
	else
		echo "Failed: $file" >&2
	fi
done
