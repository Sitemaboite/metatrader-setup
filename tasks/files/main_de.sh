#!/bin/bash

# Define the groups and display environments
RESTRICTED_GRP="restricted_group"
RESTRICTED_DE="/usr/local/bin/restricted_de.sh"
ADMIN_DE="/usr/local/bin/admin_de.sh"

# Get the current user
CURRENT_USER=$(whoami)

# Check if the user is in the restricted group
if id -nG "$CURRENT_USER" | grep -qw "$RESTRICTED_GRP"; then
    # Set the display environment to RESTRICTED_DE
    export DISPLAY_ENVIRONMENT="$RESTRICTED_DE"
else
    # Set the display environment to ADMIN_DE
    export DISPLAY_ENVIRONMENT="$ADMIN_DE"
fi

# Execute the display environment script
$DISPLAY_ENVIRONMENT
