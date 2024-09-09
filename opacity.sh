#!/bin/bash

# Check if the argument is a number between 0 and 1
if [[ $1 =~ ^[0-9](\.[0-9]+)?$ ]]; then
    if (( $(echo "$1 > 1" | bc -l) )); then
        echo "Error: The opacity value must be between 0 and 1"
        exit 1
    fi
    opacity=$1
# Also allow decimals with a leading dot
elif [[ $1 =~ ^\.[0-9]+$ ]]; then
    if (( $(echo "$1 > 1" | bc -l) )); then
        echo "Error: The opacity value must be between 0 and 1"
        exit 1
    fi
    opacity=0$1
else
    echo "Error: The opacity value must be a number"
    exit 1
fi

# Set the opacity value
echo "Setting the opacity to $opacity"
alacritty msg config window.opacity=$opacity

