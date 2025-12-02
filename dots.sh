#!/bin/env bash
ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/indyleo/dotfiles-stow"
REPO_NAME="dotfiles-stow"

if ! is_dpkg_installed stow &> /dev/null; then
    echo "Stow is not installed. Please install stow."
    exit 1
fi

cd ~/Github || exit

# Check if the repository already exists
if [[ -d "$REPO_NAME" ]]; then
    echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    git clone "$REPO_URL"
fi

cd "$REPO_NAME" || exit

./install.sh

cd "$ORIGINAL_DIR" || exit
