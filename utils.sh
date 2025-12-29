#!/bin/env bash

# Check if a package is installed (Arch/Yay based)
function is_pkg_installed() {
    # yay -Q checks for the package in the local database
    yay -Q "$1" &> /dev/null
}

# Check if a package is installed (flatpak-based)
function is_flatpak_installed() {
    flatpak list --app --columns=application | grep -Fxq "$1" &> /dev/null
}

# Function to install packages if not already installed (Yay version)
function install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_pkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if (( ${#to_install[@]} > 0 )); then
        echo "Installing: ${to_install[*]}"
        # Note: Do not use sudo with yay; it prompts when needed
        yay -S --noconfirm "${to_install[@]}"
    else
        echo "All packages are already installed."
    fi
}

# Function to install packages if not already installed (flatpak version)
function install_flatpak() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_flatpak_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "installing: ${to_install[*]}"
        flatpak install --user --noninteractive "${to_install[@]}"
    else
        echo "all packages are already installed."
    fi
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

# Function to enable services
function enable_services() {
    local services=("$@")

    for service in "${services[@]}"; do
        if ! systemctl is-enabled "$service" &> /dev/null; then
            echo "Enabling $service..."
            sudo systemctl enable --now "$service"
        else
            echo "$service is already enabled"
        fi
    done
}

# Function to clone repositories
function git_clone() {
    local repo="$1"
    local dest="$2"
    [[ -d "$dest" ]] || git clone --depth=1 "$repo" "$dest"
}

# Function to check and then source a file
function check_source() {
    local file="$1"
    [[ -f "$file" ]] && source "$file"
}
