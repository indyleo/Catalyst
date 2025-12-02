#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/Applications"
mkdir -p "$INSTALL_DIR"

REPO="ayosec/alacritty"
BINARY_NAME="alacritty"

echo "Fetching latest Alacritty release info from GitHub..."

# Fetch release data with proper error handling
RELEASE_DATA=$(curl -fsSL --max-time 15 \
        -H "Accept: application/vnd.github+json" \
        -H "User-Agent: alacritty-installer" \
        "https://api.github.com/repos/$REPO/releases/latest" 2>&1) || {
    echo "❌ Failed to fetch release data. Check your internet connection or GitHub status."
    exit 1
}

# Check if we got valid JSON
if ! echo "$RELEASE_DATA" | grep -q '"tag_name"'; then
    echo "❌ Invalid response from GitHub API"
    echo "$RELEASE_DATA" | head -n 15
    exit 1
fi

TAG_NAME=$(echo "$RELEASE_DATA" | grep -oE '"tag_name":\s*"[^"]+"' | head -n1 | sed 's/.*"tag_name":\s*"\([^"]*\)".*/\1/')
echo "✓ Latest version: $TAG_NAME"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64|amd64)
        ARCH_PATTERN="x86_64"
        ;;
    aarch64|arm64)
        ARCH_PATTERN="aarch64"
        ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Detected: $OS ($ARCH_PATTERN)"
echo ""

if [ "$OS" = "linux" ]; then
    # Construct the direct download URL for Linux binary
    # Format: alacritty-linux-x86_64.gz or alacritty-linux-aarch64.gz
    FILENAME="alacritty-linux-${ARCH_PATTERN}.gz"
    URL="https://github.com/$REPO/releases/download/$TAG_NAME/$FILENAME"

    echo "Checking for Linux binary..."

    # Test if the URL exists
    if ! curl -fsSL --head --max-time 10 "$URL" > /dev/null 2>&1; then
        echo "⚠️  Could not find $FILENAME for $TAG_NAME"
        echo ""
        echo "Tried: $URL"
        echo ""
        echo "Please check manually: https://github.com/$REPO/releases/latest"
        exit 1
    fi

    echo "Found: $URL"
    TMP_GZ=$(mktemp)

    echo "Downloading..."
    if ! curl -L --progress-bar "$URL" -o "$TMP_GZ"; then
        echo "❌ Download failed"
        rm -f "$TMP_GZ"
        exit 1
    fi

    echo "Extracting..."
    gunzip -c "$TMP_GZ" > "$INSTALL_DIR/$BINARY_NAME"
    rm -f "$TMP_GZ"

    chmod +x "$INSTALL_DIR/$BINARY_NAME"

    echo ""
    echo "✅ Alacritty $TAG_NAME installed successfully!"
    echo "   Location: $INSTALL_DIR/$BINARY_NAME"
    echo ""
    echo "Run it with: $INSTALL_DIR/$BINARY_NAME"
    echo ""
    echo "To add to PATH, add this line to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/Applications:\$PATH\""

elif [ "$OS" = "darwin" ]; then
    # Look for macOS dmg
    URL=$(echo "$RELEASE_DATA" | grep -oE '"browser_download_url":\s*"[^"]+"' | \
            sed 's/.*"browser_download_url":\s*"\([^"]*\)".*/\1/' | \
        grep -E "\.dmg$" | head -n1)

    if [ -z "${URL:-}" ]; then
        echo "⚠️  No macOS .dmg found in latest release."
        echo ""
        echo "Please check manually: https://github.com/$REPO/releases/latest"
        exit 1
    fi

    echo "Found: $URL"
    FILENAME=$(basename "$URL")
    TMP_FILE=$(mktemp)

    echo "Downloading..."
    if ! curl -L --progress-bar "$URL" -o "$TMP_FILE"; then
        echo "❌ Download failed"
        rm -f "$TMP_FILE"
        exit 1
    fi

    mv "$TMP_FILE" "$INSTALL_DIR/$FILENAME"

    echo ""
    echo "✅ Downloaded to: $INSTALL_DIR/$FILENAME"
    echo ""
    echo "To install:"
    echo "  1. Open: $INSTALL_DIR/$FILENAME"
    echo "  2. Drag Alacritty to Applications folder"

else
    echo "❌ Unsupported OS: $OS"
    echo ""
    echo "This script supports macOS and Linux only."
    exit 1
fi
