#!/bin/env bash
set -euo pipefail

GIT_REPOSITORY="https://github.com/Sitemaboite/metatrader-setup.git"

# Function to check if a command is installed
check_command() {
    if command -v "$1" &>/dev/null; then
        echo "$1 is already installed."
        return 0
    else
        echo "$1 is not installed. Proceeding with installation."
        return 1
    fi
}

# Function to install Ansible
install_ansible() {
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common python3-pip
        sudo python3 -m pip install ansible --break-system-packages
    elif [[ -f /etc/redhat-release ]]; then
        sudo dnf install -y epel-release
        sudo dnf install -y ansible
    elif [[ -f /etc/SuSE-release ]]; then
        sudo zypper refresh
        sudo zypper install -y ansible
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
}

# Function to install Git
install_git() {
    if [[ -f /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install -y git
    elif [[ -f /etc/redhat-release ]]; then
        sudo dnf install -y git
    elif [[ -f /etc/SuSE-release ]]; then
        sudo zypper refresh
        sudo zypper install -y git
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
}


# Main script execution
main() {
    check_command "ansible" || install_ansible
    check_command "git" || install_git

    echo "Ansible and Git installation completed successfully."
    sudo ansible-pull -U "$GIT_REPOSITORY" bootstrap.yml -e "my_user=$USER"
    clear
    sudo bash /opt/metatrader-setup/gh_setup.sh    
}

main
