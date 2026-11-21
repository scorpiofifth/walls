#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p coreutils
# shellcheck shell=bash

# Rename files in todo/ by SHA-256 content hash.

for file in todo/*; do
	[[ -f $file ]] || continue
	name=${file##*/}
	[[ $name == *.preview.* ]] && continue
	ext=${name##*.}
	sum=$(sha256sum -- "$file") || continue
	sum=${sum%% *}
	new=$sum
	[[ $ext != "$name" ]] && new=$sum.$ext
	[[ $new == "$name" ]] && continue
	mv -n -- "$file" "todo/$new"
done
