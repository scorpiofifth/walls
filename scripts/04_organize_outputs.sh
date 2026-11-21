#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p coreutils
# shellcheck shell=bash

# Move generated files into place and hide thumbnails.

shopt -s nullglob

for file in todo/*.preview.png; do mv -n -- "$file" thumbnails/; done
for file in todo/*.png; do mv -n -- "$file" pictures/; done

for file in thumbnails/*; do
	[[ -f $file && ${file##*/} != .* ]] || continue
	mv -n -- "$file" "thumbnails/.${file##*/}"
done
