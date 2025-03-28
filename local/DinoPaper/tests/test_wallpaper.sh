#!/bin/bash

# Path to your YAML configuration file
CONFIG_PATH="$HOME/repos/github.com/masondumas/homelab/local/DinoPaper/config.yaml"

# Starting log message
echo "🔍 Starting wallpaper lookup test script"
echo "📁 Using config file: $CONFIG_PATH"

# Check if CONFIG_PATH exists first
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "❌ Config file not found at '$CONFIG_PATH'"
  exit 1
fi

get_wallpaper() {
  local dir_path=$1
  # echo "🔎 Searching for wallpaper based on directory: '$dir_path'\n"

  # Normalize the directory path for consistent matching
  [[ "${dir_path: -1}" != "/" ]] && dir_path="$dir_path/"

  # Start searching up the directory tree
  while [[ "$dir_path" != "/" ]]; do
    # echo "  📂 Now checking YAML for key '.wallpapers.\"$dir_path\"'\n"

    wallpaper=$(yq -r ".wallpapers.\"$dir_path\"" "$CONFIG_PATH")

    if [[ "$wallpaper" != "null" ]]; then
      # echo "✅ Found wallpaper association: $wallpaper\n"
      echo "$wallpaper"
      return
    fi

    # If no match found, move one directory up
    dir_path=$(dirname "${dir_path%/}")                                          # Remove trailing "/", then take parent dir
    [[ "${dir_path: -1}" != "/" && "$dir_path" != "" ]] && dir_path="$dir_path/" # Add "/" back if not already at root
  done

  # If nothing matches, use default
  echo "🔖 No specific wallpaper found, using default."
  default_wallpaper=$(yq -r ".wallpapers.default" "$CONFIG_PATH")
  echo "🎯 Default wallpaper: $default_wallpaper"
  echo "$default_wallpaper"
}

# Execute test from current working directory
echo -e "\n🌐 Testing directory: $PWD\n"
CURRENT_WP=$(get_wallpaper "$PWD" | tr -d '\n\r')

# Clearly highlight the final result
echo -e "\n🚩 Final Wallpaper Choice → $CURRENT_WP\n"
