#!/usr/bin/env bash
builddir=$(pwd)

if ! command -v yay &> /dev/null; then
    cd ~
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd "$builddir"
else
    echo "Yay is already installed"
fi


