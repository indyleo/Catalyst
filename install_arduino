#!/usr/bin/env bash

BINDIR="$HOME/.local/bin"
APPDIR="$HOME/Applications"

# Arduino IDE
echo "Installing Arduino IDE..."
tag_arduino="$(git ls-remote --tags https://github.com/arduino/arduino-ide.git | \
  grep -oE 'refs/tags/[0-9]+\.[0-9]+\.[0-9]+$' | \
  sed 's/refs\/tags\///' | \
  sort -V | \
  tail -n 1)"
echo "Latest version: ${tag_arduino}"
mkdir -p "$APPDIR"

wget "https://github.com/arduino/arduino-ide/releases/download/${tag_arduino}/arduino-ide_${tag_arduino}_Linux_64bit.AppImage" -O "$APPDIR/Arduino-IDE"
chmod +x "$APPDIR/Arduino-IDE"

# Arduino CLI
echo "Installing Arduino CLI..."
mkdir -p "$BINDIR"

curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="$BINDIR" sh
