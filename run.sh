#!/bin/env bash

print_logo() {
    command cat << "EOF"
   ██████╗ █████╗ ████████╗ █████╗ ██╗  ██╗   ██╗███████╗████████╗
  ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║  ╚██╗ ██╔╝██╔════╝╚══██╔══╝
  ██║     ███████║   ██║   ███████║██║   ╚████╔╝ ███████╗   ██║
  ██║     ██╔══██║   ██║   ██╔══██║██║    ╚██╔╝  ╚════██║   ██║   Debian System Crafting Tool
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

echo "Creating directories..."
create_directories

# Source the utils.sh file
source ./utils.sh

# Check if the package.conf file exists
if [[ ! -f ./package.conf ]]; then
    echo "package.conf file not found. Exiting."
    exit 1
fi

# Source the package.conf file
source ./package.conf

echo "Starting system setup..."

# Check if apt or pacman is ther if not exit
if [[ -f /bin/apt || -f /usr/bin/apt ]]; then
    echo "apt is there, so good to use"
else
    echo "apt is not there. Exiting."
    exit 1
fi

if [[ -f /etc/apt/sources.list ]]; then
    sudo rm -v /etc/apt/sources.list
elif [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
    sudo rm -v /etc/apt/sources.list.d/debian.sources
fi

sudo mv -v ./debian.sources /etc/apt/sources.list.d/debian.sources

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Adding i386 architecture..."
sudo dpkg --add-architecture i386 && sudo apt update

# Install packages by category
echo "Installing system utilities..."
install_packages "${CLI_UTILS[@]}"

echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system utils..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing python tools..."
install_packages "${PYTHON_TOOLS[@]}"

echo "Installing java tools..."
install_packages "${JAVA_TOOLS[@]}"

echo "Installing webdev tools..."
install_packages "${WEBDEV_TOOLS[@]}"

echo "Installing shells..."
install_packages "${SHELLS[@]}"

echo "Installing media utils..."
install_packages "${MEDIA_UTILS[@]}"

echo "Installing vm, rdp tools..."
install_packages "${VM_RDP_TOOLS[@]}"

echo "Installing input configurations..."
install_packages "${INPUT_CONFIG[@]}"

echo "Installing gaming utils..."
install_packages "${GAMING_UTILS[@]}"

echo "Installing desktop utils..."
install_packages "${DESKTOP_LIBS[@]}"

echo "Installing misc..."
install_packages "${MISC[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

echo "Installing nerd fonts..."
install_fonts "${NERD_FONTS[@]}"

echo "Updating font cache..."
fc-cache -vf

echo "Now setting up Sddm theme"
tar -xf Nordic-Plasma-6.tar.xz -C /usr/share/sddm/themes/
mv -v sddm.conf /etc/sddm.conf

echo "Configuring services..."
for service in "${SERVICES[@]}"; do
    if ! systemctl is-enabled "$service" &> /dev/null; then
        echo "Enabling $service..."
        sudo systemctl enable "$service"
    else
        echo "$service is already enabled"
    fi
done

echo "Configuring flatpaks..."
[[ -f ./install-flatpak.sh ]] && source ./install-flatpak.sh

echo "Dot files..."
[[ -f ./dots.sh ]] && source ./dots.sh

echo "Downloading Themes..."
[[ -f ./themer.sh ]] && source ./themer.sh

echo "Configuring zsh plugins..."
[[ -f ./zsh-plugins.sh ]] && source ./zsh-plugins.sh

# Set zsh as the default login shell
chsh -s "$(which zsh)" "$USER"

# Add user to libvirt group
sudo usermod -aG libvirt "$(whoami)"

echo "Installing tailscale..."
[[ -f ./tailscale.sh ]] && source ./tailscale.sh

echo "System setup complete!"
echo "Please reboot your system to apply changes."
