#!/bin/bash

# Requirements:
# yq (to parse YAML config) - we can install this easily with your existing tools.
# feh, kitty's set-background, or hyprpaper commands, depending on your choice.

CONFIG_PATH="$HOME/repos/github.com/masondumas/homelab/local/DinoPaper/config.yaml"
CURRENT_DIR="${PWD}"

# Function to find matching wallpaper from config
get_wallpaper() {
  local dir_path=$1
  while [[ "$dir_path" != "" && "$dir_path" != "/" ]]; do
    wallpaper=$(yq -r ".wallpapers.\"$dir_path\"" "$CONFIG_PATH")
    if [[ "$wallpaper" != "null" ]]; then
      echo "$wallpaper"
      return
    fi
    dir_path=$(dirname "$dir_path")
  done
  # If nothing matches, fallback to default
  yq -r '.wallpapers.default' "$CONFIG_PATH"
}

WALLPAPER_FILE=$(get_wallpaper "$CURRENT_DIR")

# write dynamically-determined wallpaper directly into background.conf
echo "background_image /Users/masondumas/Library/CloudStorage/SynologyDrive-Downloads/wallpapers/$WALLPAPER_FILE" >~/.config/kitty/background.conf

# Example: set wallpaper with kitty
kitty @ set-background-image "/Users/masondumas/Library/CloudStorage/SynologyDrive-Downloads/wallpapers/$WALLPAPER_FILE"
