#!/bin/env bash
ORIGINAL_DIR=$(pwd)

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/

echo "Gruvbox Kvantum Themes..."
git_clone https://github.com/sachnr/gruvbox-kvantum-themes.git ~/Github/gruvbox-kvantum-themes
cd ~/Github/gruvbox-kvantum-themes
sudo mv -v Gruvbox* /usr/share/Kvantum/
cd "$ORIGINAL_DIR"

echo "Setting up vesktop theme..."
mkdir -pv ~/.config/vesktop/themes/
cp -v ./midnight-gruvbox.theme.css ~/.config/vesktop/themes

echo "Tell GTK4 / Libadwaita apps to prefer dark mode..."
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Conways GOL Wallpaper..."
git_clone https://github.com/indyleo/life-wallpaper ~/Projects/life-wallpaper
cd ~/Projects/life-wallpaper
./install.sh
cd "$ORIGINAL_DIR"

echo "Done"
