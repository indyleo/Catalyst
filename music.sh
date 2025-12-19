#!/usr/bin/env bash

APPDIR="$HOME/Applications"

# Feishin
echo "Installing feishin ..."
tag_feishin="$(
  git ls-remote --tags https://github.com/jeffvli/feishin.git |
  sed 's#.*/##' |
  grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' |
  sort -V |
  tail -n 1
)"

# Exit if no tag
if [ -z "$tag_feishin" ]; then
    echo "Error: could not determine latest Feishin version"
    exit 1
fi

echo "Latest version: ${tag_feishin}"
mkdir -p "$APPDIR"

wget "https://github.com/jeffvli/feishin/releases/download/${tag_feishin}/Feishin-linux-x86_64.AppImage" -O "$APPDIR/feishin"
chmod +x "$APPDIR/feishin"
