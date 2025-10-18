#!/bin/env bash
# Check if a package is installed (APT-based)
function is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to install packages if not already installed (APT version)
function install_packages() {
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
function install_fonts() {
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
function create_directories() {
    echo "Adding Some Directories, And Files..."
    mkdir -pv ~/Github ~/Img ~/Virt ~/Projects ~/Applications \
        ~/Pictures/Screenshots ~/Scripts ~/.local/bin ~/Desktop \
        ~/Documents ~/Documents/Markdown/Notes ~/Downloads ~/Music \
        ~/Pictures ~/Public ~/Videos/OBS  ~/.config/autostart ~/.cache \
        ~/Archives ~/Code ~/Diffs ~/Bin ~/.local/share/fonts ~/.config \
        ~/.local/share/themes ~/.local/share/icons
    touch ~/.cache/history-zsh
}

# Function to clone repositories
function git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

