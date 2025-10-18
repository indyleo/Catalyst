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
    local font_dir="$HOME/.local/share/fonts"

    # Make sure the fonts directory exists
    mkdir -p "$font_dir"

    # Get latest release tag from GitHub using git ls-remote
    local latest_tag
    latest_tag=$(git ls-remote --tags https://github.com/ryanoasis/nerd-fonts.git \
            | grep -o 'refs/tags/.*' \
            | sed 's/refs\/tags\///' \
            | grep -v '{}' \
            | sort -V \
        | tail -n 1)

    if [[ -z "$latest_tag" ]]; then
        echo "Failed to get latest Nerd Fonts release. Using v3.3.0 as fallback."
        latest_tag="v3.4.0"
    else
        echo "Latest Nerd Fonts release: $latest_tag"
    fi

    for font_name in "${font_names[@]}"; do
        # Check if any files from this font already exist
        if compgen -G "$font_dir/${font_name}*" > /dev/null; then
            echo "Font ${font_name} is already installed. Skipping..."
            continue
        fi

        echo "Installing ${font_name}..."
        wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_tag}/${font_name}.zip" -O "${font_name}.zip"
        unzip -n "${font_name}.zip" -d "$font_dir"
        rm -v "${font_name}.zip"
        echo "Done with ${font_name}"
    done

    # Refresh font cache
    fc-cache -vf "$font_dir"
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

