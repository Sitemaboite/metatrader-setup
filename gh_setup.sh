#!/bin/bash

set -euo pipefail

# Set default menu command (fzf is preferred as it does not depend on Xorg)
MENU_CMD="fzf"
if ! command -v fzf &> /dev/null; then
    printf "fzf not found. Installing...\n"
    if [[ -f /etc/redhat-release ]]; then
        sudo dnf install -y fzf ansible python3-venv curl git figlet
    elif [[ -f /etc/debian_version ]]; then
        sudo apt update && sudo apt install -y fzf ansible python3-venv curl git figlet
    else
        printf "Unsupported OS. Please install dependencies manually.\n"
        exit 1
    fi
fi

if ! command -v dmenu &> /dev/null; then
    printf "dmenu not found. Installing...\n"
    if [[ -f /etc/redhat-release ]]; then
        sudo dnf install -y dmenu
    elif [[ -f /etc/debian_version ]]; then
        sudo apt update && sudo apt install -y dmenu
    else
        printf "Unsupported OS. Please install dmenu manually.\n"
        exit 1
    fi
fi

# Function to validate GitHub token
validate_token() {
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $1" "https://api.github.com/user")
    if [[ "$RESPONSE" == "200" ]]; then
        return 0
    else
        return 1
    fi
}

# Prompt for GitHub token with validation
while true; do
    if [[ -f "$HOME/.ghtoken" ]]; then
        read -rp "GitHub Token found. Reuse it? (Yes/No): " REUSE_TOKEN
        if [[ "$REUSE_TOKEN" == "Yes" ]]; then
            GITHUB_TOKEN=$(cat "$HOME/.ghtoken")
        else
            printf "Create a GitHub token at: https://github.com/settings/tokens\n"
            read -rsp "Enter your GitHub Token: " GITHUB_TOKEN
            echo "$GITHUB_TOKEN" > "$HOME/.ghtoken"
        fi
    else
        printf "Create a GitHub token at: https://github.com/settings/tokens\n"
        read -rsp "Enter your GitHub Token: " GITHUB_TOKEN
        echo "$GITHUB_TOKEN" > "$HOME/.ghtoken"
        printf "\n"
    fi

    if validate_token "$GITHUB_TOKEN"; then
        break
    else
        printf "\nInvalid GitHub Token. Please try again.\n"
        rm -f "$HOME/.ghtoken"
    fi

done

# Fetch repositories (public & private)
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/user/repos?per_page=100" | jq -r '.[].full_name')

if [ -z "$REPOS" ]; then
    printf "No repositories found or invalid token!\n"
    exit 1
fi

# Prompt user to select a repository
SELECTED_REPO=$(printf "%s" "$REPOS" | $MENU_CMD)

if [ -n "$SELECTED_REPO" ]; then
    printf "Selected Repository: %s\n" "$SELECTED_REPO"
else
    printf "No repository selected!\n"
    exit 1
fi