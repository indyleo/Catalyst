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

[[ -f ./debian.sources ]] && sudo mv -v ./debian.sources /etc/apt/sources.list.d/debian.sources

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Adding i386 architecture..."
sudo dpkg --add-architecture i386 && sudo apt update

# Install packages by category
echo "Installing packages..."

echo "Installing core cli packages..."
install_packages "${CORE_CLI[@]}"

echo "Installing file utils..."
install_packages "${FILE_UTILS[@]}"

echo "Installing shell enhancers..."
install_packages "${SHELL_ENHANCERS[@]}"

echo "Installing terminal utils..."
install_packages "${TERMINAL_FUN[@]}"

echo "Installing system tools..."
install_packages "${SYSTEM_TOOLS[@]}"

echo "Installing dev tools..."
install_packages "${NVIDIA_TOOLS[@]}"

echo "Installing dev packages..."
install_packages "${DEV_GENERAL[@]}"

echo "Installing build tools..."
install_packages "${BUILD_TOOLS[@]}"

echo "Installing gui libs..."
install_packages "${BUILD_GUI_LIBS[@]}"

echo "Installing python packages..."
install_packages "${PYTHON_ENV[@]}"

echo "Installing java packages..."
install_packages "${JAVA_ENV[@]}"

echo "Installing web dev packages..."
install_packages "${WEB_DEV[@]}"

echo "Installing media utils..."
install_packages "${MEDIA_UTILS[@]}"

echo "Installing audio utils..."
install_packages "${AUDIO_UTILS[@]}"

echo "Installing vm tools..."
install_packages "${VM_TOOLS[@]}"

echo "Installing gaming tools..."
install_packages "${GAMING_TOOLS[@]}"

echo "Installing theming tools..."
install_packages "${THEMING[@]}"

echo "Installing qt libs..."
install_packages "${QT_LIBS[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

echo "Installing gui utils..."
install_packages "${GUI_UTILS[@]}"

echo "Installing input utils..."
install_packages "${INPUT_UTILS[@]}"

echo "Installing script dialogs..."
install_packages "${SCRIPT_DIALOGS[@]}"

echo "Installing xdg apps..."
install_packages "${XDG_APPS[@]}"

echo "Installing wm tools..."
install_packages "${WM_TOOLS[@]}"

echo "Installing nerd fonts..."
install_fonts "${NERD_FONTS[@]}"

echo "Updating font cache..."
fc-cache -vf

echo "Configuring flatpaks..."
[[ -f ./install-flatpak.sh ]] && source ./install-flatpak.sh

echo "Installing brave..."
[[ -f ./brave.sh ]] && source ./brave.sh

echo "Compiling..."
[[ -f ./compile.sh ]] && source ./compile.sh

echo "Dot files..."
[[ -f ./dots.sh ]] && source ./dots.sh

echo "Suckless Tools..."
[[ -f ./suckless.sh ]] && source ./suckless.sh

echo "Installing clipmenu..."
[[ -f ./clipmenu.sh ]] && source ./clipmenu.sh

echo "Downloading Themes..."
[[ -f ./themer.sh ]] && source ./themer.sh

echo "Configuring zsh plugins..."
[[ -f ./zsh-plugins.sh ]] && source ./zsh-plugins.sh

# Add user to libvirt group
sudo usermod -aG libvirt "$(whoami)"

echo "Installing tailscale..."
[[ -f ./tailscale.sh ]] && source ./tailscale.sh

echo "Setting up UFW..."
[[ -f ./ufw.sh ]] && source ./ufw.sh

echo "Configuring services..."
for service in "${SERVICES[@]}"; do
    if ! systemctl is-enabled "$service" &> /dev/null; then
        echo "Enabling $service..."
        sudo systemctl enable "$service"
    else
        echo "$service is already enabled"
    fi
done

echo "Installing ultrakill grub theme..."
wget -O- https://github.com/YouStones/ultrakill-revamp-grub-theme/raw/main/install.sh | bash -s -- --lang English

echo "System setup complete!"
echo "Please reboot your system to apply changes."
