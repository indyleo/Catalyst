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

# List of suckless programs to install
programs=("dmenu" "slock" "st" "tabbed" "slstatus" "dwmblocks" "dwm")

for prog in "${programs[@]}"; do
    echo "Installing $prog..."
    if cd "$prog"; then
        sudo make clean install || { echo "❌ Failed to install $prog"; exit 1; }
        cd ..
    else
        echo "❌ Directory $prog not found!"
        exit 1
    fi
done

cd "$ORIGINAL_DIR" || exit
