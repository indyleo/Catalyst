APPIMGAGE_DIR="$HOME/Applications"

# Installing Moonlight
echo "Installing Moonlight..."
tag_moonlight=$(git ls-remote --tags https://github.com/moonlight-stream/moonlight-qt.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
# Remove the 'v' prefix from the tag for the filename
version_moonlight=${tag_moonlight#v}
wget "https://github.com/moonlight-stream/moonlight-qt/releases/download/${tag_moonlight}/Moonlight-${version_moonlight}-x86_64.AppImage" -O "$APPIMGAGE_DIR"/moonlight
chmod +x "$APPIMGAGE_DIR"/moonlight
