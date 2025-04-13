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

# Check if the clone was successful
if [ $? -eq 0 ]; then
    cd "$REPO_NAME"
    stow --target="$HOME" --adopt zsh
    stow --target="$HOME" --adopt shell
    stow --target="$HOME" --adopt figletfonts
    stow --target="$HOME" --adopt xdg
    stow --target="$HOME" --adopt git
    stow --target="$HOME" --adopt yazi
    stow --target="$HOME" --adopt tmux
    stow --target="$HOME" --adopt nvim
    stow --target="$HOME" --adopt ohmyposh
    stow --target="$HOME" --adopt alacritty
    stow --target="$HOME" --adopt fastfetch
    cd "$ORIGINAL_DIR"
else
    echo "Failed to clone the repository."
    exit 1
fi
