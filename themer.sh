#!/bin/env bash
ORIGINAL_DIR=$(pwd)

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/

echo "Gruvbox Kvantum Themes..."
cd ~/Github
git_clone https://github.com/sachnr/gruvbox-kvantum-themes.git
cd gruvbox-kvantum-themes
sudo mv -v Gruvbox* /usr/share/Kvantum/
cd "$ORIGINAL_DIR"

echo "Done"
