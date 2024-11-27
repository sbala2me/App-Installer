#!/bin/bash

# Function to install using apt
install_with_apt() {
    echo "Installing $1 using apt-get..."
    sudo apt-get install -y "$1" || {
        echo "Failed with apt-get. Trying apt..."
        sudo apt install -y "$1"
    }
}

# Function to uninstall using apt
uninstall_with_apt() {
    echo "Uninstalling $1 using apt-get..."
    sudo apt-get remove -y "$1" || {
        echo "Failed with apt-get. Trying apt..."
        sudo apt remove -y "$1"
    }
}

# Function to manage repositories with apt
manage_repositories_apt() {
    echo "Apt repository management:"
    echo "1) Add repository"
    echo "2) Remove repository"
    read -p "Enter your choice: " apt_choice
    case $apt_choice in
        1)
            read -p "Enter the repository to add (e.g., ppa:user/ppa-name): " repo
            sudo add-apt-repository "$repo"
            sudo apt-get update
            ;;
        2)
            read -p "Enter the repository to remove (e.g., ppa:user/ppa-name): " repo
            sudo add-apt-repository --remove "$repo"
            sudo apt-get update
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Function to install using dnf
install_with_dnf() {
    echo "Installing $1 using dnf..."
    sudo dnf install -y "$1"
}

# Function to uninstall using dnf
uninstall_with_dnf() {
    echo "Uninstalling $1 using dnf..."
    sudo dnf remove -y "$1"
}

# Function to manage repositories with dnf
manage_repositories_dnf() {
    echo "DNF repository management:"
    echo "1) Enable repository"
    echo "2) Disable repository"
    read -p "Enter your choice: " dnf_choice
    case $dnf_choice in
        1)
            read -p "Enter the repository name to enable: " repo
            sudo dnf config-manager --set-enabled "$repo"
            ;;
        2)
            read -p "Enter the repository name to disable: " repo
            sudo dnf config-manager --set-disabled "$repo"
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Function to install using pacman
install_with_pacman() {
    echo "Installing $1 using pacman..."
    sudo pacman -S --noconfirm "$1"
}

# Function to uninstall using pacman
uninstall_with_pacman() {
    echo "Uninstalling $1 using pacman..."
    sudo pacman -R --noconfirm "$1"
}

# Function to manage repositories with pacman
manage_repositories_pacman() {
    echo "Pacman repository management:"
    echo "1) Add repository"
    echo "2) Remove repository"
    read -p "Enter your choice: " pacman_choice
    case $pacman_choice in
        1)
            read -p "Enter the repository to add (e.g., custom-repo): " repo
            echo -e "\n[$repo]\nServer = <repository-url>" | sudo tee -a /etc/pacman.conf
            sudo pacman -Syy
            ;;
        2)
            read -p "Enter the repository to remove: " repo
            sudo sed -i "/^\[$repo\]/,/^$/d" /etc/pacman.conf
            sudo pacman -Syy
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Function to search and install using flatpak
install_with_flatpak() {
    echo "Searching for $1 in Flatpak..."
    search_results=$(flatpak search "$1")

    if [ -z "$search_results" ]; then
        echo "No Flatpak apps found for '$1'."
        return 1
    else
        echo "Flatpak search results:"
        echo "$search_results"
        echo "Please select the Flatpak app to install:"
        read -p "Enter the full application ID or package name: " flatpak_app_id
        echo "Installing $flatpak_app_id using Flatpak..."
        flatpak install -y "$flatpak_app_id"
    fi
}

# Function to uninstall using flatpak
uninstall_with_flatpak() {
    echo "Uninstalling $1 using Flatpak..."
    flatpak uninstall -y "$1"
}

# Function to manage repositories with Flatpak
manage_repositories_flatpak() {
    echo "Flatpak repository management:"
    echo "1) Add Flathub"
    echo "2) Remove Flathub"
    read -p "Enter your choice: " flatpak_choice
    case $flatpak_choice in
        1)
            echo "Adding Flathub repository..."
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            ;;
        2)
            echo "Removing Flathub repository..."
            flatpak remote-delete flathub
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# Main menu
echo "Select an action:"
echo "1) Install an app"
echo "2) Uninstall an app"
echo "3) Manage repositories"
read -p "Enter your choice (1, 2, or 3): " action

case $action in
    1)
        echo "Select the package manager to install an app with:"
        echo "1) apt (Debian-based distros)"
        echo "2) dnf (Fedora-based distros)"
        echo "3) pacman (Arch-based distros)"
        echo "4) flatpak (Universal)"
        read -p "Enter your choice (1, 2, 3, or 4): " pm_choice
        read -p "Enter the app you want to install: " app_name
        case $pm_choice in
            1) install_with_apt "$app_name" ;;
            2) install_with_dnf "$app_name" ;;
            3) install_with_pacman "$app_name" ;;
            4) install_with_flatpak "$app_name" ;;
            *) echo "Invalid package manager choice." ;;
        esac
        ;;
    2)
        echo "Select the package manager to uninstall a ceartain app with:"
        echo "1) apt (Debian-based distros)"
        echo "2) dnf (Fedora-based distros)"
        echo "3) pacman (Arch-based distros)"
        echo "4) flatpak (Universal)"
        read -p "Enter your choice (1, 2, 3, or 4): " pm_choice
        read -p "Enter the app you want to uninstall: " app_name
        case $pm_choice in
            1) uninstall_with_apt "$app_name" ;;
            2) uninstall_with_dnf "$app_name" ;;
            3) uninstall_with_pacman "$app_name" ;;
            4) uninstall_with_flatpak "$app_name" ;;
            *) echo "Invalid package manager choice." ;;
        esac
        ;;
    3)
        echo "Select the package manager for repository management:"
        echo "1) apt (Debian-based distros)"
        echo "2) dnf (Fedora-based distros)"
        echo "3) pacman (Arch-based distros)"
        echo "4) flatpak (Universal)"
        read -p "Enter your choice (1, 2, 3, or 4): " pm_choice
        case $pm_choice in
            1) manage_repositories_apt ;;
            2) manage_repositories_dnf ;;
            3) manage_repositories_pacman ;;
            4) manage_repositories_flatpak ;;
            *) echo "Invalid package manager choice." ;;
        esac
        ;;
    *)
        echo "Invalid action. Exiting."
        exit 1
        ;;
esac

