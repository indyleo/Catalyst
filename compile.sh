#!/bin/env bash

builddir=$(pwd)

echo "Cloning repositories..."
git_clone https://github.com/bayasdev/envycontrol.git ~/Github/envycontrol
git_clone https://github.com/indyleo/scripts.git ~/.local/scripts
git_clone https://github.com/jesseduffield/lazygit.git ~/Github/lazygit
git_clone https://github.com/ayn2op/discordo ~/Github/discordo
git_clone https://github.com/tsujan/Kvantum.git ~/Github/Kvantum
git_clone https://codeberg.org/AnErrupTion/ly.git ~/Github/ly
git_clone https://github.com/DavidBuchanan314/fusee-nano.git ~/Github/fusee-nano
git_clone https://github.com/mwh/dragon.git ~/Github/dragon
git_clone https://git.dayanhub.com/sagi/subsonic-tui.git ~/Github/subsonic-tui
git_clone https://github.com/XPhyro/lf-sixel.git ~/Github/lf-sixel

echo "Installing go tools..."
go install github.com/doronbehar/pistol/cmd/pistol@latest
go install github.com/charmbracelet/glow@latest
go install github.com/walles/moar@latest

echo "Installing lazygit..."
cd ~/Github/lazygit
go install
cd "$builddir"

echo "Installing discordo..."
cd ~/Github/discordo
go install
cd "$builddir"

echo "Installing lf-sixel..."
cd ~/Github/lf-sixel
env CGO_ENABLED=0 go install -ldflags="-s -w" github.com/horriblename/lf@latest
cd "$builddir"

echo "Installing lua linter..."
sudo luarocks install luacheck

echo "Installing spotdl..."
pipx install spotdl

echo "Installing protonup..."
pipx install protonup

echo "Installing bitwarden cli..."
sudo npm install -g @bitwarden/cli

echo "Installing adblock..."
pip install adblock --break-system-packages

echo "Installing kvantum..."
cd ~/Github/Kvantum/Kvantum
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install

echo "Installing nvim..."
cd ~/.local/scripts
./bob.py install
./bob.py install nightly
cd "$builddir"

echo "Installing rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

echo "Installing neovide..."
cargo install --git https://github.com/neovide/neovide

echo "Installing caligula..."
cargo install caligula

echo "Installing espanso..."
tag_esp=$(git ls-remote --tags https://github.com/espanso/espanso.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget https://github.com/espanso/espanso/releases/download/${tag_esp}/espanso-debian-x11-amd64.deb -O espanso.deb
sudo dpkg -i espanso.deb
rm -fv espanso.deb
espanso service register
systemctl --user enable espanso.service
cd "$builddir"

echo "Installing via-app..."
tag_via=$(git ls-remote --tags https://github.com/the-via/releases | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
ver_via=$(echo "$tag_via" | sed 's/v//')
wget "https://github.com/the-via/releases/releases/download/${tag_via}/via-${ver_via}-linux.deb" -O via-app.deb
sudo dpkg -i via-app.deb
rm -fv via-app.deb

echo "Installing zig..."
tag_zig=$(git ls-remote --tags https://github.com/ziglang/zig.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
wget "https://ziglang.org/download/${tag_zig}/zig-x86_64-linux-${tag_zig}.tar.xz" -O zig.tar.xz
tar xf zig.tar.xz
rm -fv zig.tar.xz
cd zig-x86_64-linux-${tag_zig}
sudo cp -v zig /usr/local/bin/zig
sudo cp -vr lib /usr/local/lib/zig
cd "$builddir"
rm -rfv zig-x86_64-linux-${tag_zig}

echo "Installing ly..."
cd ~/Github/ly
tag_ly=$(git ls-remote --tags https://codeberg.org/AnErrupTion/ly.git | grep -o 'refs/tags/.*' | sed 's/refs\/tags\///' | grep -v '{}' | sort -V | tail -n 1)
git checkout "$tag_ly"
sudo zig build installexe
sudo systemctl disable getty@tty2.service
cd "$builddir"
sudo cp -v config.ini /etc/ly/config.ini

echo "Installing fusee-nano..."
cd ~/Github/fusee-nano
sudo make install
cd "$builddir"

echo "Installing dragon..."
cd ~/Github/dragon
make install
cd "$builddir"

echo "Installing cargo-binstall..."
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

echo "Installing gurk..."
cargo binstall --git https://github.com/boxdot/gurk-rs gurk

echo "Installing twt..."
cargo install twitch-tui

echo "Installing subsonic-tui..."
cd ~/Github/subsonic-tui
make build
make install
cd "$builddir"
