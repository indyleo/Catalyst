#!/bin/env bash

# Make Sure Script Is Not Run As Root
if [[ "$(id -u)" -eq 0 ]]; then
    echo "This script cannot be run as root/sudo. Exiting."
    exit 1
fi

set -euo pipefail # Exit on error
trap 'echo "Error occurred at line $LINENO"' ERR

# Script Variables
builddir=$(pwd)

# Function to create directories
create_dirs() {
    echo "########################################"
    echo "## Adding Some Directories, And Files ##"
    echo "########################################"
    mkdir -pv ~/Github ~/Img ~/Virt ~/Projects ~/Applications \
        ~/Pictures/Screenshots ~/Scripts ~/.local/bin ~/Desktop \
        ~/Documents ~/Documents/Markdown ~/Downloads ~/Music \
        ~/Pictures ~/Public ~/Videos/OBS ~/.config/autostart ~/.cache
    touch ~/.cache/history-zsh
}

create_dirs

# Function to clone repositories
git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

# Clone repositories
git_clone https://github.com/bayasdev/envycontrol.git ~/Github/envycontrol
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
git_clone https://github.com/jesseduffield/lazygit.git ~/Github/lazygit
git_clone https://github.com/taj-ny/kwin-effects-forceblur.git ~/Github/kwin-effects-forceblur

echo "#################"
echo "## Go Programs ##"
echo "#################"
go install github.com/doronbehar/pistol/cmd/pistol@latest
go install github.com/charmbracelet/glow@latest
cd lazygit
go install
cd "$builddir"

echo "#####################"
echo "## Python Programs ##"
echo "#####################"
pipx installl spotdl

echo "##################"
echo "## Kwin Effects ##"
echo "##################"
cd ~/Github/kwin-effects-forceblur
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
make -j
sudo make install
cd "$builddir"

echo "############"
echo "## Rustup ##"
echo "############"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
[[ -f "$HOME/.cargo/env" ]] || . "$HOME/.cargo/env"

echo "###################"
echo "## Rust Programs ##"
echo "###################"
cargo install bob-nvim
bob install stable
bob use stable

echo "##################"
echo "## Oh My Posh ##"
echo "##################"
curl -s https://ohmyposh.dev/install.sh | bash -s

# Function to download and extract fonts
download_font() {
    local font_name="$1"
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/${font_name}.zip"
    unzip -n "${font_name}.zip" -d ~/.local/share/fonts
    rm -v "${font_name}.zip"
    echo "Donw with ${font_name}"
}

echo "###########################"
echo "## Installing Nerd Fonts ##"
echo "###########################"
mkdir -pv ~/.local/share/fonts
download_font "FiraCode"
download_font "Ubuntu"
download_font "UbuntuMono"
download_font "CascadiaCode"
download_font "NerdFontsSymbolsOnly"

fc-cache -vf

echo "########################################"
echo "## Moving, Deleting, And Adding Files ##"
echo "########################################"
mkdir -pv ~/.config
git_clone https://github.com/indyleo/Wallpapers.git ~/Pictures/Wallpapers/
mv -v fastfetch git nvim lf tmux alacritty ohmyposh mimeapps.list user-dirs.locale user-dirs.dirs ~/.config/
rm -v ~/.bashrc ~/.profile ~/.zshenv ~/.zshrc
mv -v .profile .zshenv .zshrc .functionrc .aliasrc .xsession .Xresources ~/

# Cursor Theme
echo "###################"
echo "## Cursors Theme ##"
echo "###################"
git_clone https://github.com/alvatip/Nordzy-cursors.git ~/Github/Nordzy-cursors
mv -v ~/Github/Nordzy-cursors/themes/* ~/.local/share/icons

# Icons Theme
echo "#################"
echo "## Icons Theme ##"
echo "#################"
wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.local/share/icons" sh
mv -v desktopfiles/* ~/.local/share/icons/Papirus-Dark/128x128/apps

# Zsh Setup
echo "###############"
echo "## Zsh Setup ##"
echo "###############"
mkdir -pv ~/Zsh-Plugins
git_clone https://github.com/zsh-users/zsh-history-substring-search.git ~/Zsh-Plugins/zsh-history-substring-search
git_clone https://github.com/zsh-users/zsh-completions.git ~/Zsh-Plugins/zsh-completions
git_clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/Zsh-Plugins/zsh-you-should-use
git_clone https://github.com/hlissner/zsh-autopair.git ~/Zsh-Plugins/zsh-autopair

# Set zsh as the default login shell
chsh -s "$(which zsh)" "$USER"

# Add user to libvirt group
sudo usermod -aG libvirt "$(whoami)"

echo "###############"
echo "## Tailscale ##"
echo "###############"
curl -fsSL https://tailscale.com/install.sh | sh

echo "############"
echo "## Floorp ##"
echo "############"
curl -fsSL https://floorp.app/install.sh | sh

echo "#####################"
echo "## Via (Keyboard) ##"
echo "#####################"
wget https://github.com/the-via/releases/releases/download/v3.0.0/via-3.0.0-linux.deb
sudo dpkg -i via-3.0.0-linux.deb
rm -fv via-3.0.0-linux.deb

echo "##################"
echo "## Flatpak Repo ##"
echo "##################"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "#####################"
echo "## Flatpak Install ##"
echo "#####################"
flatpak install -y io.github.dweymouth.supersonic com.obsproject.Studio io.github.arunsivaramanneo.GPUViewer org.fedoraproject.MediaWriter com.chatterino.chatterino net.lutris.Lutris \
    com.github.tchx84.Flatseal org.prismlauncher.PrismLauncher com.heroicgameslauncher.hgl xyz.xclicker.xclicker dev.vencord.Vesktop org.winehq.Wine com.usebottles.bottles \
    com.valvesoftware.steam net.davidotek.pupgui2

echo "Setup complete!"
