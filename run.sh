#!/usr/bin/env bash
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
set -Eeuo pipefail # Exit on error, propagate ERR trap into functions
trap 'echo "Error occurred at line $LINENO"' ERR

# Always run relative to this script's own directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Make sure ~/.local/bin is on PATH for the rest of this script
# (pipx/uv/claude installers only update PATH for *future* shells via rc files)
export PATH="$HOME/.local/bin:$PATH"

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
if [[ -f ./pacman.conf ]]; then
    sudo cp -fv ./pacman.conf /etc/pacman.conf
fi
echo "Updating system..."
sudo pacman -Syu
# Installing yay
echo "Installing yay..."
check_source ./yay.sh
echo "Installing all packages..."
install_packages "${ALL[@]}"
echo "Sunshine wayland stuff..."
if command -v sunshine >/dev/null 2>&1; then
    sudo setcap cap_sys_admin+p "$(readlink -f "$(command -v sunshine)")"
else
    echo "sunshine not found on PATH, skipping setcap."
fi
echo "Configuring flatpaks..."
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Installing flatpaks..."
install_flatpak "${FLATPAKS[@]}"
echo "Compiling apps..."
echo "Cloning repositories..."
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://git.dayanhub.com/sagi/subsonic-tui.git ~/Github/subsonic-tui
echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx install spotdl
hash -r

echo "Installing protonup..."
pipx install protonup
hash -r

echo "Installing claude code..."
curl -fsSL https://claude.ai/install.sh | bash
hash -r
if command -v claude >/dev/null 2>&1; then
    echo "claude installed: $(claude --version)"
else
    echo "claude not found on PATH after install — check install location."
fi

echo "Installing free claude code..."
pipx install uv
hash -r
uv tool install git+https://github.com/Alishahryar1/free-claude-code.git
uv tool update-shell
hash -r
"$HOME"/.local/share/uv/tools/free-claude-code/bin/fcc-init

echo "Installing subsonic-tui..."
builddir="$(pwd)"
cd ~/Github/subsonic-tui
make build
make install
cd "$builddir"
hash -r

echo "Installing TerraMap..."
mkdir -pv ~/.local/bin ~/.local/share/applications ~/.local/share/icons
builddir="$(pwd)"
cd ~/Applications
npx nativefier --name "TerraMap" --internal-urls ".*" "https://terramap.github.io/"
ln -sf ~/Applications/TerraMap-linux-x64/TerraMap ~/.local/bin/TerraMap
cd "$builddir"
cp -rf ./TerraMap.desktop ~/.local/share/applications/
cp -rf ./TerraMap.png ~/.local/share/icons/TerraMap.png
echo "Dot files..."
check_source ./dots.sh
echo "Downloading Themes..."
check_source ./themer.sh
echo "Configuring zsh plugins..."
check_source ./zsh-plugins.sh
echo "Setting up UFW..."
check_source ./ufw.sh
echo "Configuring services..."
enable_services "${SERVICES[@]}"
echo "Setting tailscale..."
sudo tailscale set --operator="$USER" --ssh

echo "Setting zsh as default shell..."
if command -v zsh >/dev/null 2>&1; then
    sudo usermod -s "$(command -v zsh)" "$USER"
else
    echo "zsh not found on PATH, skipping shell change."
fi

echo "Setting up groups..."
sudo usermod -aG libvirt "$USER"
echo "System setup complete!"
echo "Please reboot your system to apply changes (shell and group changes require a new login)."
