#!/bin/env bash
# Check if a package is installed (APT-based)
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to install packages if not already installed (APT version)
install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Installing: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    else
        echo "All packages are already installed."
    fi
}

# Function to download and extract fonts
install_fonts() {
    local font_names=("$@")
    for font_name in "${font_names[@]}"; do
        echo "Installing ${font_name}..."
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/${font_name}.zip"
        unzip -n "${font_name}.zip" -d ~/.local/share/fonts
        rm -v "${font_name}.zip"
        echo "Done with ${font_name}"
    done
}

# Function to create directories
create_directories() {
    echo "Adding Some Directories, And Files..."
    mkdir -pv ~/Github ~/Img ~/Virt ~/Projects ~/Applications \
        ~/Pictures/Screenshots ~/Scripts ~/.local/bin ~/Desktop \
        ~/Documents ~/Documents/Markdown/Notes ~/Downloads ~/Music \
        ~/Pictures ~/Public ~/Videos/OBS ~/Videos/vid/ ~/Videos/aud/ \
        ~/.config/autostart ~/.cache ~/.local/share/fonts ~/.config \
        ~/.local/share/themes ~/.local/share/icons
    touch ~/.cache/history-zsh ~/.discordo_token
}

# Function to clone repositories
git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

