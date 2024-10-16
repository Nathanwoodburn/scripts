#!/bin/bash

# Storage locations to check
locations=(
    "/home/nathan"
    "/home/nathan/Nextcloud"
)

icons=(
    "󰋜"
    ""
)

# Check for first arg
if [ -z "$1" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    # Check if storage is full
    for i in "${!locations[@]}"; do
        # Check if the location exists
        location=${locations[$i]}
        if [ -d "$location" ]; then
            # Get icon for location
            icon=${icons[$i]}

            # Get the current usage
            size=$(du -hs "$location" | awk '{print $1}')
            echo -en "${YELLOW}${icon} ${NC}${size} "

        fi
    done
    echo ""

else
    RED='%{F#ff0000}'
    GREEN='%{F#ff60d090}'
    YELLOW='%{F#F0C674}'
    BLUE='%{F#0000ff}'
    NC='%{F-}'

    # Check if storage is full
    for i in "${!locations[@]}"; do
        # Check if the location exists
        location=${locations[$i]}
        if [ -d "$location" ]; then
            # Get icon for location
            icon=${icons[$i]}

            # Get the current usage (discard error output)
            size=$(du -hs "$location" 2>/dev/null | awk '{print $1}')
            echo -en "%{A1:/home/nathan/scripts/zellij.sh --cwd $location zsh:}${YELLOW}${icon} ${NC}${size}%{A} "
        fi
    done
    echo ""
fi
