#!/bin/env bash
set -euo pipefail

GIT_REPOSITORY=https://github.com/Sitemaboite/metatrader-setup.git

# Function to check if Ansible is installed
check_ansible() {
    if command -v ansible &>/dev/null; then
        echo "Ansible is already installed."
        return 0
    else
        echo "Ansible is not installed. Proceeding with installation."
        return 1
    fi
}

ansible_pull_run() {
    ansible-pull $GIT_REPOSITORY
}

# Function to install Ansible on Debian/Ubuntu
install_ansible_debian() {
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
}

# Function to install Ansible on RedHat/CentOS
install_ansible_redhat() {
    sudo dnf install -y epel-release
    sudo dnf install -y ansible
}

# Function to install Ansible on SUSE
install_ansible_suse() {
    sudo zypper refresh
    sudo zypper install -y ansible
}

# Main script execution
if check_ansible; then
    ansible_pull_run
    exit 0
fi

# Detect the Linux distribution and install Ansible accordingly
if [[ -f /etc/debian_version ]]; then
    install_ansible_debian
elif [[ -f /etc/redhat-release ]]; then
    install_ansible_redhat
elif [[ -f /etc/SuSE-release ]]; then
    install_ansible_suse
else
    echo "Unsupported Linux distribution."
    exit 1
fi

echo "Ansible installation completed successfully."
ansible_pull_run