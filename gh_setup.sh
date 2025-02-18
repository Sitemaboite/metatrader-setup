#!/bin/bash

set -euo pipefail

DEST_DIR="/opt/metatrader-setup"

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
    if [[ -f "$DEST_DIR/.ghtoken" ]]; then
        read -rp "GitHub Token found. Reuse it? (Yes/No): " REUSE_TOKEN
        if [[ "$REUSE_TOKEN" == "Yes" ]]; then
            GITHUB_TOKEN=$(cat "$DEST_DIR/.ghtoken")
        else
            printf "Create a GitHub token at: https://github.com/settings/tokens\n"
            read -rsp "Enter your GitHub Token: " GITHUB_TOKEN
            echo "$GITHUB_TOKEN" > "$DEST_DIR/.ghtoken"
        fi
    else
        printf "Create a GitHub token at: https://github.com/settings/tokens\n"
        read -rsp "Enter your GitHub Token: " GITHUB_TOKEN
        echo "$GITHUB_TOKEN" > "$DEST_DIR/.ghtoken"
        printf "\n"
    fi

    if validate_token "$GITHUB_TOKEN"; then
        break
    else
        printf "\nInvalid GitHub Token. Please try again.\n"
        rm -f "$DEST_DIR/.ghtoken"
    fi

done

# Define menu command (e.g., fzf for fuzzy finder)
MENU_CMD="fzf"

# Fetch repositories (public & private)
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/user/repos?per_page=100" | jq -r '.[].full_name')

if [ -z "$REPOS" ]; then
    printf "No repositories found or invalid token!\n"
    exit 1
fi

# Prompt user to select a repository
SELECTED_REPO=$(printf "%s" "$REPOS" | $MENU_CMD --prompt="Select a repository to pull on host: ")

if [ -n "$SELECTED_REPO" ]; then
    printf "Selected Repository: %s\n" "$SELECTED_REPO"
    echo https://$GITHUB_TOKEN@github.com/$SELECTED_REPO > $DEST_DIR/.ghrepo
else
    printf "No repository selected!\n"
    exit 1
fi