#!/bin/env bash

git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

echo "Cloning zsh plugins"
git_clone https://github.com/zsh-users/zsh-history-substring-search.git ~/Zsh-Plugins/zsh-history-substring-search
git_clone https://github.com/zsh-users/zsh-completions.git ~/Zsh-Plugins/zsh-completions
git_clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/Zsh-Plugins/zsh-you-should-use
git_clone https://github.com/hlissner/zsh-autopair.git ~/Zsh-Plugins/zsh-autopair

echo "Done"
