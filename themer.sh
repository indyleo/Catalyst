#!/bin/env bash

git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/
git_clone https://gitlab.com/dwt1/wallpapers.git ~/Pictures/wallpaper/

echo "Cursors Theme"
git_clone https://github.com/guillaumeboehm/Nordzy-hyprcursors.git ~/Github/Nordzy-cursors
~/Github/Nordzy-cursors/install.sh

echo "Icons Theme"
wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.local/share/icons" sh

echo "Done"
