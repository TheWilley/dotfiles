#!/bin/bash

# Exit immediately if a command returns a non-zero exit status
set -e

# Check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a package is installed
package_installed() {
    dpkg -l | grep -qw "$1"
}

# Helper function to install apt dependencies
install_apt_dependencies() {
    for dependency in "$@"; do
        if ! command_exists "$dependency"; then
            if ! package_installed "$dependency"; then
                echo "Installing $dependency..."
                apt update
                apt install -y "$dependency"
            fi
        fi
    done
}

# Helper function to copy a file
copy_file() {
    local source_file="$1"
    local dest_file="$2"

    if [ -f "$dest_file" ]; then
        echo "File already exists: $dest_file. Skipping copy."
    else
        cp "$source_file" "$dest_file"
        echo "Copied $source_file to $dest_file."
    fi
}

setup_keys() {
    # Vivaldi
    wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | dd of=/usr/share/keyrings/vivaldi-browser.gpg
    echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | dd of=/etc/apt/sources.list.d/vivaldi-archive.list
    apt update && apt install vivaldi-stable

    # Spotify
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
}

install_apt_packages() {
    dependencies=("wget" "git" "curl" "flatpak" "rsync" "jq" "vivaldi-stable" "spotify-client")

    install_apt_dependencies "${dependencies[@]}"
}

install_i3() {
    dependencies=("i3" "i3blocks" "i3lock" "rofi" "scrot")

    install_apt_dependencies "${dependencies[@]}"
}

install_flatpak_packages() {
    flatpak_dependencies=("md.obsidian.Obsidian" "com.github.tchx84.Flatseal" "org.shotcut.Shotcut" "org.blender.Blender")
    
    for dependency in "${flatpak_dependencies[@]}"; do
        if ! command_exists "$dependency"; then
            flatpak install flathub "$dependency"
        fi
    done
}

install_dotfiles() {
    git clone --separate-git-dir=$HOME/.dotfiles https://github.com/TheWilley/dotfiles.git tmpdotfiles
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
    rm -r tmpdotfiles
}

setup_keys
install_apt_packages
install_flatpak_packages
install_dotfiles
install_i3
