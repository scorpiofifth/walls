# Wallpapers

[Preview](PREVIEW.md)

## Instructions

1. download all the wallpapers to `todo` folder.
2. from the project root, run:

```bash
nix-shell scripts/01_convert_images.sh
nix-shell scripts/02_rename_by_sha256.sh
nix-shell scripts/03_create_thumbnails.sh
nix-shell scripts/04_organize_outputs.sh
nix-shell scripts/05_generate_preview.sh
```

## Tricks

### Download from wallheavn.cc

```bash
# Thanks to amogh09/wallhaven-sync
./wallhaven-sync \
    --wallhaven-api-key "<key>" \
    --wallpaper-dir todo \
    --wallhaven-username ScorpioFifth \
    --collection-label Default
```
