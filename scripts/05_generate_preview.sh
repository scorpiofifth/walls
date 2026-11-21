#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p coreutils findutils
# shellcheck shell=bash

# Regenerate PREVIEW.md from hidden thumbnails.

{
	echo '# Preview'
	echo
	find thumbnails -maxdepth 1 -type f -name '.*.preview.png' -printf '%f\n' |
		LC_ALL=C sort |
		while IFS= read -r name; do echo "![](./thumbnails/$name)"; done
} > PREVIEW.md
