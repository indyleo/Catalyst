#!/bin/env bash
# Check if a package is installed (APT-based)
function is_dpkg_installed() {
    dpkg -s "$1" &> /dev/null
}

# Check if a package is installed (flatpak-based)
function is_flatpak_installed() {
    flatpak list --app --columns=application | grep -Fxq "$1" &> /dev/null
}

# Function to install packages if not already installed (APT version)
function install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_dpkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if (( ${#to_install[@]} > 0 )); then
        echo "Installing: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    else
        echo "All packages are already installed."
    fi
}

# function to install packages if not already installed (flatpak version)
function install_flatpak() {
    local packages=("$@")
    local to_install=()

    # list installed refs only, avoiding substring matches
    local installed_refs
    installed_refs=$(flatpak list --app --columns=application)

    for pkg in "${packages[@]}"; do
        if ! is_flatpak_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "installing: ${to_install[*]}"
        flatpak install --noninteractive "${to_install[@]}"
    else
        echo "all packages are already installed."
    fi
}

# Function to download and extract fonts
function install_fonts() {
    local font_names=("$@")
    local font_dir="$HOME/.local/share/fonts"

    # Make sure the fonts directory exists
    mkdir -p "$font_dir"

    # Get latest release tag from GitHub
    local latest_tag
    latest_tag=$(git ls-remote --tags https://github.com/ryanoasis/nerd-fonts.git \
            | awk -F/ '/refs\/tags\/v/{print $3}' \
            | grep -v '{}' \
            | sort -V \
        | tail -n 1)

    if [[ -z "$latest_tag" ]]; then
        echo "Failed to get latest Nerd Fonts release. Using v3.4.0 as fallback."
        latest_tag="v3.4.0"
    else
        echo "Latest Nerd Fonts release: $latest_tag"
    fi

    for font_name in "${font_names[@]}"; do
        # Check if font is already installed
        if compgen -G "$font_dir/${font_name}*" > /dev/null; then
            echo "Font ${font_name} is already installed. Skipping..."
            continue
        fi

        echo "Installing ${font_name}..."
        if wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_tag}/${font_name}.zip" -O "${font_name}.zip"; then
            if command -v unzip >/dev/null 2>&1; then
                unzip -n "${font_name}.zip" -d "$font_dir"
                rm -v "${font_name}.zip"
                echo "Done with ${font_name}"
            else
                echo "Error: unzip not installed. Cannot extract ${font_name}.zip"
            fi
        else
            echo "Error downloading ${font_name}.zip"
        fi
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

