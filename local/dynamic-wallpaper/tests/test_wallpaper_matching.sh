#!/bin/bash

CONFIG_PATH="../config.yaml"

test_wallpaper() {
  test_dir=$1
  expected_wallpaper=$2
  result=$(bash ../set_wallpaper.sh "$test_dir")
  if [[ "$result" == "$expected_wallpaper" ]]; then
    echo "PASS: $test_dir correctly matched to $expected_wallpaper"
  else
    echo "FAIL: $test_dir matched incorrectly (expected: $expected_wallpaper, got: $result)"
  fi
}

# Test exact match
test_wallpaper "/home/mason/dotfiles" "dotfiles_bg.png"

# Test nested directory—expected to inherit from parent
test_wallpaper "/home/mason/dotfiles/nested_dir" "dotfiles_bg.png"

# Test fallback
test_wallpaper "/home/mason/some-other-dir" "default_bg.png"
