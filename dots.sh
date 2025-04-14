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
    espanso
)

FILES_CONFIG=(
    mimeapps.list
    user-dirs.dirs
    user-dirs.locale
)

echo "Removing old dotfiles..."
for file in "${FILES_HOME[@]}"; do
    if [ -f "$HOME/$file" ]; then
        command rm -fv "$HOME/$file"
    fi
done

for dir in "${DIRS_CONFIG[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        command rm -rfv "$HOME/.config/$dir"
    fi
done

for file in "${FILES_CONFIG[@]}"; do
    if [ -f "$HOME/.config/$file" ]; then
        command rm -fv "$HOME/.config/$file"
    fi
done

if [ -d ~/.local/share/figletfonts ]; then
    command rm -rfv ~/.local/share/figletfonts
fi

echo "Stowing dotfiles..."
# Check if the clone was successful
if [ $? -eq 0 ]; then
    cd "$REPO_NAME"
    stow --target="$HOME" -v zsh
    stow --target="$HOME" -v shell
    stow --target="$HOME" -v figletfonts
    stow --target="$HOME" -v xdg
    stow --target="$HOME" -v git
    stow --target="$HOME" -v yazi
    stow --target="$HOME" -v tmux
    stow --target="$HOME" -v nvim
    stow --target="$HOME" -v ohmyposh
    stow --target="$HOME" -v alacritty
    stow --target="$HOME" -v fastfetch
    stow --target="$HOME" -v espanso
    cd "$ORIGINAL_DIR"
else
    echo "Failed to clone the repository."
    exit 1
fi
