#!/bin/env bash

builddir=$(pwd)

# Function to clone repositories
git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

echo "Cloning repositories..."
git_clone https://github.com/bayasdev/envycontrol.git ~/Github/envycontrol
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
git_clone https://github.com/jesseduffield/lazygit.git ~/Github/lazygit
git_clone https://github.com/taj-ny/kwin-effects-forceblur.git ~/Github/kwin-effects-forceblur
git_clone https://github.com/tsujan/Kvantum.git ~/Github/Kvantum

echo "Installing go tools..."
go install github.com/doronbehar/pistol/cmd/pistol@latest
go install github.com/charmbracelet/glow@latest
cd ~/Github/lazygit
go install
cd "$builddir"

echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx installl spotdl

echo "Installing kwin-effects-forceblur..."
cd ~/Github/kwin-effects-forceblur
mkdir build
cd build
cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
make -j
sudo make install
cd "$builddir"

echo "Installing kvantum..."
cd ~/Github/Kvantum/Kvantum
mkdir build && cd build
cmake ..
make
sudo make install
cd "$builddir"

echo "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
[[ -f "$HOME/.cargo/env" ]] || . "$HOME/.cargo/env"

echo "Installing bob-nvim..."
cargo install bob-nvim
bob install stable
bob use stable

echo "Installing oh-my-posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s
