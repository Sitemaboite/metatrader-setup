#!/usr/bin/env bash

set -euo pipefail

ask_and_run_ansible(){
    figlet -f slant "MetaTrader Installer v2"

    # Prompt for SSH connection details
    echo "Enter the target host (e.g., user@hostname or 'localhost' for local execution you must have exchanged ssh key):"
    read TARGET_HOST

    # Use fzf to select the playbook
    echo "Select installation type:"
    echo "1) Git Setup Only (gh_setup.yml)"
    echo "2) Full Installation (setup.yml)"
    read -p "Enter choice (1 or 2): " choice

    case $choice in
        1) PLAYBOOK="gh_setup.yml" ;;
        2) PLAYBOOK="setup.yml" ;;
        *) echo "Invalid choice" && exit 1 ;;
    esac

    # Run the Ansible playbook
    if [[ "$TARGET_HOST" == "localhost" ]]; then
        ansible-playbook -i localhost, -c local /opt/metatrader-setup/$PLAYBOOK --ask-become-pass
    else
        ansible-playbook -i "$TARGET_HOST," /opt/metatrader-setup/$PLAYBOOK --ask-pass
    fi
}

ask_and_run_ansible