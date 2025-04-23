#!/bin/env bash
ORIGINAL_DIR=$(pwd)
git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

echo "Downloading Wallpapers..."
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/
git_clone https://gitlab.com/dwt1/wallpapers.git ~/Pictures/wallpaper/

echo "Cursors Theme"
git_clone https://github.com/guillaumeboehm/Nordzy-cursors ~/Github/Nordzy-cursors
~/Github/Nordzy-cursors/install.sh

echo "Icons Theme"
wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.local/share/icons" sh

echo "Setting up Nord GTK Theme"
mkdir -vp ~/.local/share/themes
tag_nord=$(git ls-remote --tags https://github.com/EliverLara/Nordic.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://github.com/EliverLara/Nordic/releases/download/${tag_nord}/Nordic.tar.xz" -O Nordic.tar.xz
tar xf Nordic.tar.xz -C ~/.local/share/themes/
rm -fv Nordic.tar.xz
gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic"

echo "Setting up Nord Kvantum Theme"
git clone https://github.com/tonyfettes/materia-nord-kvantum.git
cd materia-nord-kvantum
sudo cp -vr Kvantum/MateriaNordDark /usr/share/Kvantum
cd "$ORIGINAL_DIR"
rm -rfv materia-nord-kvantum

echo "Now setting up Sddm theme"
if [[ -f /bin/sddm ]] &> /dev/null; then
    [[ -f ./Nordic-Plasma-6.tar.xz ]] &&  sudo tar -xf Nordic-Plasma-6.tar.xz -C /usr/share/sddm/themes/
    [[ -f ./sddm.conf ]] && sudo cp -v sddm.conf /etc/sddm.conf
fi

echo "Done"
