#!/bin/bash

# Select a random wallpaper from the Wallpapers directory
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

# Generate hyprpaper config
cat > /tmp/hyprpaper.conf <<EOF
preload = $WALLPAPER

wallpaper = ,$WALLPAPER

splash = false

ipc = off
EOF

# Kill existing hyprpaper instance if running
pkill hyprpaper

# Start hyprpaper with the generated config
hyprpaper -c /tmp/hyprpaper.conf &
