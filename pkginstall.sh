#!/bin/env bash

# Check if the script is running as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root. Exiting."
    exit 1
fi

set -euo pipefail # Exit on error
trap 'echo "Error occurred at line $LINENO"' ERR

# Check if apt or pacman is ther if not exit
if [[ -f /bin/apt || -f /usr/bin/apt ]]; then
    echo "apt is there, so good to use"
else
    echo "apt is not there. Exiting."
    exit 1
fi

# Update the system
apt update && apt upgrade -y

# Add 32 bit support
dpkg --add-architecture i386

# Update the pkg list
apt update

# Install the packages
apt install -y \
    direnv yad fzf locate gh tree build-essential git cmake make libhidapi-dev gpg openssl tldr trash-cli g++ gcc wget curl \
    python3 unzip tar python3-setuptools zoxide luarocks lf shellcheck python3-venv meson stow apt-transport-https eza \
    qalc libtool libtool-bin ninja-build autoconf automake python3-pil bat flake8 jq poppler-utils odt2txt highlight catdoc \
    docx2txt genisoimage libimage-exiftool-perl libmagic-dev libmagic1 brightnessctl xbacklight zsh zsh-syntax-highlighting zsh-autosuggestions \
    ripgrep fd-find neovim npm flatpak golang-go python3-pip pipx cowsay cmatrix tty-clock lolcat fastfetch htop bash bash-completion \
    openjdk-17-jdk openjdk-17-jre gradle transmission-qt transmission-cli geoip-bin virt-manager xsel alacritty timeshift \
    gparted yt-dlp mediainfo ffmpegthumbnailer ffmpeg cava playerctl mpv peek vlc mesa-utils nvidia-driver nvidia-cuda-toolkit nvidia-cuda-dev \
    firmware-misc-nonfree fonts-font-awesome fontconfig fonts-noto fonts-ubuntu fonts-jetbrains-mono extra-cmake-modules qt6-tools-dev kwin-dev \
    libkf6configwidgets-dev gettext libkf6crash-dev libkf6globalaccel-dev libkf6kio-dev libkf6service-dev libkf6notifications-dev libkf6kcmutils-dev \
    libkdecorations3-dev libxcb-composite0-dev libxcb-randr0-dev libxcb-shm0-dev libx11-dev libxext-dev qt6-base-dev qt6-svg-dev libkf6windowsystem-dev \
    qt6-base-dev-tools figlet solaar piper xdo xdotool

echo "Packages installed successfully"

echo "Now setting up Sddm theme"

tar -xf Nordic-Plasma-6.tar.xz -C /usr/share/sddm/themes/
mv -v sddm.conf /etc/sddm.conf

