#!/bin/env bash
ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/indyleo/dotfiles-stow"
REPO_NAME="dotfiles-stow"

is_stow_installed() {
    dpkg -s "stow" &> /dev/null
}

if ! is_stow_installed &> /dev/null; then
    echo "Stow is not installed. Please install stow."
    exit 1
fi

cd ~/Github

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
    echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    git clone "$REPO_URL"
fi

for f in ~/.bashrc ~/.profile ~/.zshenv ~/.zshrc; do
    if [ -f "$f" ]; then
        rm -v "$f"
        break
    fi
done

# Check if the clone was successful
if [ $? -eq 0 ]; then
    cd "$REPO_NAME"
    stow --target="$HOME" zsh
    stow --target="$HOME" shell
    stow --target="$HOME" figletfonts
    stow --target="$HOME" xdg
    stow --target="$HOME" git
    stow --target="$HOME" yazi
    stow --target="$HOME" tmux
    stow --target="$HOME" nvim
    stow --target="$HOME" ohmyposh
    stow --target="$HOME" alacritty
    stow --target="$HOME" fastfetch
    cd "$ORIGINAL_DIR"
else
    echo "Failed to clone the repository."
    exit 1
fi
