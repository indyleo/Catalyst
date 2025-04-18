#!/bin/env bash
ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/cdown/clipmenu"
REPO_NAME="clipmenu"

cd ~/Github

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
    echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
    git clone "$REPO_URL"
fi

cd "$REPO_NAME"

sudo make clean install

cd "$ORIGINAL_DIR"
