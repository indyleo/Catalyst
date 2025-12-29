#!/bin/env bash

builddir=$(pwd)

echo "Cloning repositories..."
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://git.dayanhub.com/sagi/subsonic-tui.git ~/Github/subsonic-tui

echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx install spotdl

echo "Installing protonup..."
pipx install protonup

echo "Installing subsonic-tui..."
if ! command -v subsonic-tui &> /dev/null; then
    cd ~/Github/subsonic-tui
    make build
    make install
    cd "$builddir"
else
    echo "subsonic-tui is already installed"
fi
