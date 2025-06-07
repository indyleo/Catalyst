#!/bin/env bash
ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/indyleo/suckless"
REPO_NAME="suckless"

cd ~/Github || exit

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
    echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    git clone "$REPO_URL"
fi

cd "$REPO_NAME" || exit

echo "Installing suckless programs"

echo "Installing dmenu..."
cd dmenu || exit
sudo make clean install
cd ..

echo "Installing slock..."
cd slock || exit
sudo make clean install
cd ..

echo "Installing st..."
cd st || exit
sudo make clean install
cd ..

echo "Installing slstatus..."
cd slstatus || exit
sudo make clean install
cd ..

echo "Installing dwmblocks..."
cd dwmblocks || exit
sudo make clean install
cd ..

echo "Installing dwm..."
cd dwm || exit
sudo make clean install
cd ..

cd "$ORIGINAL_DIR" || exit
