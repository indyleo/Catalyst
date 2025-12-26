#!/bin/env bash
ORIGINAL_DIR=$(pwd)

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/

echo "Cursor Theme's"
mkdir -vp ~/.local/share/icons ~/.icons
namer_capitaine=$(curl -s https://api.github.com/repos/sainnhe/capitaine-cursors/releases/latest | jq -r .name)
wget "https://github.com/sainnhe/capitaine-cursors/releases/download/${namer_capitaine}/Linux.zip" -O Cursors.zip
unzip Cursors.zip -d ~/.local/share/icons
rm -fv Cursors.zip
cd "$ORIGINAL_DIR"

echo "Nord Icon Theme"
wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.local/share/icons" sh

echo "Setting up Nord GTK Theme"
mkdir -vp ~/.local/share/themes
tag_nord=$(git ls-remote --tags https://github.com/EliverLara/Nordic.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://github.com/EliverLara/Nordic/releases/download/${tag_nord}/Nordic.tar.xz" -O Nordic.tar.xz
tar xf Nordic.tar.xz -C ~/.local/share/themes/
rm -fv Nordic.tar.xz

echo "Setting up Nord Kvantum Theme"
sudo mkdir -vp /usr/share/Kvantum
git_clone https://github.com/tonyfettes/materia-nord-kvantum.git materia-nord-kvantum
cd materia-nord-kvantum
sudo cp -vr Kvantum/MateriaNordDark /usr/share/Kvantum
cd "$ORIGINAL_DIR"
rm -rfv materia-nord-kvantum

echo "Done"
