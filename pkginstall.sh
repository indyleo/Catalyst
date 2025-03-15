#!/bin/env bash

# Check if the script is running as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root. Exiting."
    exit 1
fi

set -euo pipefail # Exit on error
trap 'echo "Error occurred at line $LINENO"' ERR

# Check if apt or pacman is ther if not exit
if [[ -f /bin/apt ]]; then
    echo "apt is installed, so good to use"
    distro="deb"
elif [[ -f /bin/pacman ]]; then
    echo "pacman is installed, so good to use"
    distro="arch"
else
    echo "apt or pacman is not installed. Exiting."
    distro="none"
    exit 1
fi

if [[ "$distro" == "deb" ]]; then
    # Update the system
    apt update && apt upgrade -y

    # Install the packages
    apt install -y \
        direnv yad fzf locate gh tree build-essential git cmake make libhidapi-dev gpg openssl tldr trash-cli g++ gcc wget curl \
        python3 unzip tar python3-setuptools zoxide luarocks lf shellcheck python3-venv meson stow apt-transport-https eza \
        qalc libtool libtool-bin ninja-build autoconf automake python3-pil bat flake8 jq poppler-utils odt2txt highlight catdoc \
        docx2txt genisoimage libimage-exiftool-perl libmagic-dev libmagic1 brightnessctl xbacklight zsh zsh-syntax-highlighting zsh-autosuggestions \
        ripgrep fd-find neovim npm flatpak golang-go python3-pip pipx cowsay cmatrix tty-clock lolcat fastfetch htop bash bash-completion \
        openjdk-17-jdk openjdk-17-jre gradle transmission-qt transmission-cli geoip-bin virt-manager xsel alacritty timeshift \
        gparted yt-dlp mediainfo ffmpegthumbnailer ffmpeg cava playerctl mpv peek vlc mesa-utils nvidia-driver nvidia-cuda-toolkit nvidia-cuda-dev \
        firmware-misc-nonfree fonts-font-awesome fontconfig fonts-noto fonts-ubuntu fonts-jetbrains-mono

elif [[ "$distro" == "arch" ]]; then
    # Update the system
    pacman -Syu --noconfirm

    # Install the packages
    # TODO: dont know if these are correct pkg names
    pacman -S --noconfirm \
        direnv yad fzf locate gh tree build-essential git cmake make libhidapi-dev gpg openssl tldr trash-cli g++ gcc wget curl \
        python3 unzip tar python3-setuptools zoxide luarocks lf shellcheck python3-venv meson stow apt-transport-https eza \
        qalc libtool libtool-bin ninja-build autoconf automake python3-pil bat flake8 jq poppler-utils odt2txt highlight catdoc \
        docx2txt genisoimage libimage-exiftool-perl libmagic-dev libmagic1 brightnessctl xbacklight zsh zsh-syntax-highlighting zsh-autosuggestions \
        ripgrep fd-find neovim npm flatpak golang-go python3-pip pipx cowsay cmatrix tty-clock lolcat fastfetch htop bash bash-completion \
        openjdk-17-jdk openjdk-17-jre gradle transmission-qt transmission-cli geoip-bin virt-manager xsel alacritty timeshift \
        gparted yt-dlp mediainfo ffmpegthumbnailer ffmpeg cava playerctl mpv peek vlc mesa-utils nvidia-driver nvidia-cuda-toolkit nvidia-cuda-dev \
        firmware-misc-nonfree fonts-font-awesome fontconfig fonts-noto fonts-ubuntu fonts-jetbrains-mono
fi
