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

FILES_HOME=(
    .zshrc
    .zshenv
    .zprofile
    .profile
    .bashrc
    .bash_profile
    .hooksrc
    .aliasrc
    .functionrc
)

DIRS_CONFIG=(
    alacritty
    tmux
    nvim
    ohmyposh
    fastfetch
    yazi
    git
)

FILES_CONFIG=(
    mimeapps.list
    user-dirs.dirs
    user-dirs.locale
)

for file in "${FILES_HOME[@]}"; do
    if [ -f "$HOME/$file" ]; then
        command rm -f "$HOME/$file"
    fi
done

for dir in "${DIRS_CONFIG[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        command rm -rf "$HOME/.config/$dir"
    fi
done

for file in "${FILES_CONFIG[@]}"; do
    if [ -f "$HOME/.config/$file" ]; then
        command rm -f "$HOME/.config/$file"
    fi
done

if [ -d ~/.local/share/figletfonts ]; then
    command rm -rf ~/.local/share/figletfonts
fi

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
