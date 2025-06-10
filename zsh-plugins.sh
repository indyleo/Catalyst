#!/bin/env bash

git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zplugins"

echo "Cloning zsh plugins"
git_clone https://github.com/zsh-users/zsh-history-substring-search.git "${PLUGINS_DIR}"/zsh-history-substring-search
git_clone https://github.com/zsh-users/zsh-completions.git "${PLUGINS_DIR}"/zsh-completions
git_clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${PLUGINS_DIR}"/zsh-you-should-use
git_clone https://github.com/hlissner/zsh-autopair.git "${PLUGINS_DIR}"/zsh-autopair

echo "Done"
