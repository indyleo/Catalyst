#!/bin/env bash
ORIGINAL_DIR=$(pwd)

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/

echo "Setting up Calamity	GTK Theme & Icon Theme..."
mkdir -vp ~/.local/share/themes
wget "https://github.com/indyleo/ClamityGTK/raw/refs/heads/main/CalamityTheme.tar.gz" -O CalamityTheme.tar.gz
tar xf CalamityTheme.tar.gz -C ~/.local/share/themes/
rm -fv CalamityTheme.tar.gz
mkdir -vp ~/.local/share/icons
wget "https://github.com/indyleo/ClamityGTK/raw/refs/heads/main/CalamityIcons.tar.gz" -O CalamityIcons.tar.gz
tar xf CalamityIcons.tar.gz -C ~/.local/share/icons/
rm -fv CalamityIcons.tar.gz

echo "Done"
