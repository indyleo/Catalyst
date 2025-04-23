#!/bin/env bash

builddir=$(pwd)

# Function to clone repositories
git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

echo "Cloning repositories..."
git_clone https://github.com/bayasdev/envycontrol.git ~/Github/envycontrol
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://github.com/jesseduffield/lazygit.git ~/Github/lazygit
git_clone https://github.com/taj-ny/kwin-effects-forceblur.git ~/Github/kwin-effects-forceblur
git_clone https://github.com/tsujan/Kvantum.git ~/Github/Kvantum
git_clone https://codeberg.org/AnErrupTion/ly.git ~/Github/ly

echo "Installing go tools..."
go install github.com/doronbehar/pistol/cmd/pistol@latest
go install github.com/charmbracelet/glow@latest
go install github.com/walles/moar@latest
cd ~/Github/lazygit
go install
cd "$builddir"

echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx install spotdl

echo "Installing kwin-effects-forceblur..."
cd ~/Github/kwin-effects-forceblur
if command -v kwin_x11 &> /dev/null; then
    mkdir build
    cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
    make -j
    sudo make install
    cd "$builddir"
else
    echo "Skipping kwin-effects-forceblur, kwin_x11 not found"
    cd "$builddir"
fi

echo "Installing kvantum..."
cd ~/Github/Kvantum/Kvantum
mkdir build && cd build
cmake ..
make
sudo make install
cd "$builddir"

echo "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

echo "Installing bob-nvim..."
cargo install bob-nvim
bob install stable
bob use stable

echo "Installing yazi..."
cargo install --locked yazi-fm yazi-cli

echo "Installing neovide..."
cargo install --git https://github.com/neovide/neovide

echo "Installing oh-my-posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Installing espanso..."
tag_esp=$(git ls-remote --tags https://github.com/espanso/espanso.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget https://github.com/espanso/espanso/releases/download/${tag_esp}/espanso-debian-x11-amd64.deb -O espanso.deb
sudo apt-get install ./espanso.deb -y
rm -fv espanso.deb
espanso service register
systemctl --user enable espanso.service
cd "$builddir"

echo "Installing zig..."
tag_zig=$(git ls-remote --tags https://github.com/ziglang/zig.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://ziglang.org/download/${tag_zig}/zig-linux-x86_64-${tag_zig}.tar.xz" -O zig.tar.xz
tar xf zig.tar.xz
rm -fv zig.tar.xz
cd zig-linux-x86_64-${tag_zig}
sudo cp -v zig /usr/local/bin/zig
sudo cp -vr lib /usr/local/lib/zig
cd "$builddir"
rm -rfv zig-linux-x86_64-${tag_zig}

echo "Installing ly..."
cd ~/Github/ly
sudo zig build installexe
sudo systemctl disable getty@tty2.service
cd "$builddir"
sudo cp -v config.ini /etc/ly/config.ini
if [[ -f /bin/sddm ]]; then
    sudo systemctl disable sddm
fi
sudo systemctl enable ly
