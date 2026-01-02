#!/bin/env bash

builddir=$(pwd)

echo "Cloning repositories..."
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts

echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx install spotdl

echo "Installing protonup..."
pipx install protonup
