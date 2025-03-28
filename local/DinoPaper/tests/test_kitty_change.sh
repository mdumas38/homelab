#!/bin/bash

# Path to your YAML config
CONFIG_PATH="$HOME/repos/github.com/masondumas/homelab/local/DinoPaper/config.yaml"

# Path to Kitty's background configuration
KITTY_BG_CONFIG="$HOME/.config/kitty/background.conf"

# Base directory for wallpaper images
WALLPAPER_BASE_DIR="/Users/masondumas/Library/CloudStorage/SynologyDrive-Downloads/wallpapers"

# Function that retrieves wallpaper name based on current directory
get_wallpaper() {
  local dir_path=$1
  [[ "${dir_path: -1}" != "/" ]] && dir_path="$dir_path/"

  while [[ "$dir_path" != "/" ]]; do
    wallpaper=$(yq -r ".wallpapers.\"$dir_path\"" "$CONFIG_PATH")
    if [[ "$wallpaper" != "null" ]]; then
      echo "$wallpaper"
      return
    fi
    dir_path=$(dirname "${dir_path%/}")
    [[ "${dir_path: -1}" != "/" && "$dir_path" != "" ]] && dir_path="$dir_path/"
  done

  yq -r ".wallpapers.default" "$CONFIG_PATH"
}

# Get the wallpaper filename
CURRENT_WP=$(get_wallpaper "$PWD" | tr -d '\n\r')

# Ensure this result is clear
echo "🎯 Selected wallpaper: $CURRENT_WP"

# Form the full path to the wallpaper
FULL_WALLPAPER_PATH="$WALLPAPER_BASE_DIR/$CURRENT_WP"

# Double-check path correctness by printing:
echo "✅ Wallpaper full path: $FULL_WALLPAPER_PATH"

# Update Kitty background.conf safely
echo "background_image $FULL_WALLPAPER_PATH" >"$KITTY_BG_CONFIG"
echo "✍️  Updated Kitty's background configuration at $(date)"

kitty @ set-background-image "$FULL_WALLPAPER_PATH"
