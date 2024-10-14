#!/bin/bash

# This script is used to create a virtual environment for the project

# Check if the virtual environment already exists
if [ -d ".venv" ]; then
    # Check if arg exit passed
    if [ "$1" = "exit" ]; then
        echo "Exiting virtual environment"
        deactivate
    else

        # Check if the virtual environment is active
        if [ -n "$VIRTUAL_ENV" ]; then
            echo "Virtual environment is active"
        else
            echo "Activating existing virtual environment"
            source .venv/bin/activate
        fi
    fi
else
    # Create the virtual environment
    python3 -m venv .venv

    # Activate the virtual environment
    source .venv/bin/activate

    # Install the required packages
    if [ -f "requirements.txt" ]; then
        echo "Installing required packages"
        python3 -m pip install -r requirements.txt
    fi
fi
