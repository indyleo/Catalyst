#!/bin/env bash
ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/indyleo/suckless"
REPO_NAME="suckless"

cd ~/Github

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
    echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    git clone "$REPO_URL"
fi

cd "$REPO_NAME"

echo "Installing suckless programs"

echo "Installing dmenu..."
cd dmenu
sudo make clean install
cd ..

echo "Installing slock..."
cd slock
sudo make clean install
cd ..

echo "Installing st..."
cd st
sudo make clean install
cd ..

echo "Installing slstatus..."
cd slstatus
sudo make clean install
cd ..

echo "Installing dwm..."
cd dwm
sudo make clean install
cd ..

cd "$ORIGINAL_DIR"
