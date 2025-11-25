APPIMGAGE_DIR="$HOME/Applications"

# Sunrise
echo "Installing Sunshine..."
tag_sunshine=$(git ls-remote --tags https://github.com/LizardByte/Sunshine.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://github.com/LizardByte/Sunshine/releases/tag/${tag_sunshine}/sunshine.AppImage" -O "$APPIMGAGE_DIR"/sunshine
chmod +x "$APPIMGAGE_DIR"/sunshine

# Installing Moonlight
echo "Installing Moonlight..."
tag_moonlight=$(git ls-remote --tags https://github.com/moonlight-stream/moonlight-qt.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://github.com/moonlight-stream/moonlight-qt/releases/tag/${tag_moonlight}/Moonlight-${tag_moonlight}-x86_64.AppImage" -O "$APPIMGAGE_DIR"/moonlight
chmod +x "$APPIMGAGE_DIR"/moonlight
