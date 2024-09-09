#!/bin/bash

# Check if there is an argument

blur=true
if [ -z "$1" ]; then
    blur=true
else
    # Check if argument is true or false (or 1 or 0)
    if [[ $1 == "true" || $1 == "1" ]]; then
        blur=true
    elif [[ $1 == "false" || $1 == "0" ]]; then
        blur=false
    else
        echo "Error: The blur value must be true or false"
        exit 1
    fi
fi

# Set the blur value
echo "Setting the blur to $blur"
alacritty msg config window.blur=$blur
