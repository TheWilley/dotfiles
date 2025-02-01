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

    # Spotify
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list

    # VS Code
    echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
}

install_apt_packages() {
    dependencies=("wget" "gpg" "git" "curl" "flatpak" "rsync" "jq"  "apt-transport-https" "vivaldi-stable" "spotify-client" "code")

    install_apt_dependencies "${dependencies[@]}"
}

install_i3() {
    dependencies=("i3" "i3blocks" "i3lock" "rofi" "scrot")

    install_apt_dependencies "${dependencies[@]}"
}

install_flatpak_packages() {
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    flatpak_dependencies=("md.obsidian.Obsidian" "com.github.tchx84.Flatseal")
    
    for dependency in "${flatpak_dependencies[@]}"; do
        if ! command_exists "$dependency"; then
            flatpak install flathub -y "$dependency"
        fi
    done
}

install_dotfiles() {
    git clone --separate-git-dir=$HOME/.dotfiles https://github.com/TheWilley/dotfiles.git tmpdotfiles
    rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
    rm -r tmpdotfiles
}

configure_git() {
    # Define GitHub user and email as variables
    github_user="thewilley"
    github_email="89783791+TheWilley@users.noreply.github.com" 
    
    # Set Git user name and email using the variables
    echo "Configuring Git username and email..."
    git config --global user.name "$github_user"
    git config --global user.email "$github_email"

    # Check if SSH key exists, generate one if not
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        echo "SSH key not found. Generating SSH key..."
        ssh-keygen -t ed25519 -b 4096 -C "$github_email" -f "$HOME/.ssh/id_ed25519"
        echo "SSH key generated."
    else
        echo "SSH key already exists."
    fi

    # Add SSH key to the SSH agent
    echo "Adding SSH key to the SSH agent..."
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"

    # Display the SSH key to be added to GitHub
    echo "Please add the following SSH key to your GitHub account:"
    cat "$HOME/.ssh/id_ed25519.pub"

    # Open the SSH keys page in the default browser (if you want to add it manually)
    echo "Opening GitHub SSH keys page..."
    xdg-open "https://github.com/settings/keys" &

    # Confirming setup is complete
    echo "Git credentials setup completed. You can now connect to GitHub using SSH!"
}


setup_keys
install_apt_packages
install_flatpak_packages
install_dotfiles
install_i3
configure_git
