#!/bin/env bash

function print_logo() {
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

[[ -f ./debian.sources ]] && sudo cp -v ./debian.sources /etc/apt/sources.list.d/debian.sources

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

echo "Configuring flatpaks..."
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing flatpaks..."
install_flatpak "${FLATPAKS[@]}"

echo "Installing remote managment software..."
check_source ./remote.sh

echo "Installing wezterm & alacritty..."
check_source ./terminal.sh

echo "Installing arduino..."
check_source ./arduino.sh

echo "Installing signal..."
check_source ./signal.sh

echo "Installing syncthing..."
check_source ./syncthing.sh

echo "Compiling apps..."
check_source ./compile.sh

echo "Dot files..."
check_source ./dotfiles.sh

echo "Suckless Tools..."
check_source ./suckless.sh

echo "Downloading Themes..."
check_source ./themes.sh

echo "Configuring zsh plugins..."
check_source ./zsh-plugins.sh

# Add user to libvirt group
sudo usermod -aG libvirt "$(whoami)"

echo "Installing tailscale..."
check_source ./tailscale.sh

echo "Setting up UFW..."
check_source ./ufw.sh

echo "Configuring services..."
enable_services "${SERVICES[@]}"

echo "Installing ultrakill grub theme..."
wget -O- https://github.com/YouStones/ultrakill-revamp-grub-theme/raw/main/install.sh | bash -s -- --lang English

echo "Setting zsh as default shell..."
sudo usermod -s "$(which zsh)" "$USER"

echo "Setting up groups..."
sudo usermod -a -G dialout "$USER"

echo "System setup complete!"
echo "Please reboot your system to apply changes."
