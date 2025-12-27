#!/bin/env bash

function print_logo() {
    command cat << "EOF"
   ██████╗ █████╗ ████████╗ █████╗ ██╗  ██╗   ██╗███████╗████████╗
  ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║  ╚██╗ ██╔╝██╔════╝╚══██╔══╝
  ██║     ███████║   ██║   ███████║██║   ╚████╔╝ ███████╗   ██║
  ██║     ██╔══██║   ██║   ██╔══██║██║    ╚██╔╝  ╚════██║   ██║   Archlinux System Crafting Tool
  ╚██████╗██║  ██║   ██║   ██║  ██║███████╗██║   ███████║   ██║   By: Indyleo
   ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚══════╝   ╚═╝
EOF
}

# Clear and then print the logo
clear
print_logo

set -euo pipefail # Exit on error
trap 'echo "Error occurred at line $LINENO"' ERR

# Check if utils is there
if [[ ! -f ./utils.sh ]]; then
    echo "utils.sh file not found. Exiting."
    exit 1
fi

# Source the utils.sh file
source ./utils.sh

echo "Creating directories..."
create_directories

# Check if the package.conf file exists
if [[ ! -f ./package.conf ]]; then
    echo "package.conf file not found. Exiting."
    exit 1
fi

# Source the package.conf file
source ./package.conf

echo "Starting system setup..."

[[ -f ./pacman.conf ]] && sudo cp -fv ./pacman.conf /etc/pacman.conf

echo "Updating system..."
sudo pacman -Syu

# Installing yay
echo "Installing yay..."
check_source ./yay.sh

echo "Installing all packages..."
install_packages "${ALL[@]}"

echo "Setting tailscale..."
sudo tailscale set --operator="$USER" --ssh

echo "Sunshine wayland stuff..."
sudo setcap cap_sys_admin+p "$(readlink -f "$(which sunshine)")"

echo "Configuring flatpaks..."
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing flatpaks..."
install_flatpak "${FLATPAKS[@]}"

echo "Compiling apps..."
check_source ./compile.sh

echo "Dot files..."
check_source ./dotfiles.sh

echo "Downloading Themes..."
check_source ./themes.sh

echo "Configuring zsh plugins..."
check_source ./zsh-plugins.sh

echo "Setting up UFW..."
check_source ./ufw.sh

echo "Configuring services..."
enable_services "${SERVICES[@]}"

echo "Setting zsh as default shell..."
sudo usermod -s "$(which zsh)" "$USER"

echo "Setting up groups..."
sudo usermod -aG dialout "$USER"
sudo usermod -aG libvirt "$USER"

echo "System setup complete!"
echo "Please reboot your system to apply changes."
