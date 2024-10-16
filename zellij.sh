#!/bin/bash

# Check if focus on zellig window worked wmctrl -a zellij 
if [ -z "$(wmctrl -l | grep Zellij)" ]; then
    echo "No terminal running" > /tmp/message
    polybar-msg action message hook 0
else
    wmctrl -a Zellij
fi

# Get arguments and run in new zellij pane
if [ "$#" -ne 0 ];
then
    # Check if --cwd flag is passed
    if [ "$1" == "--cwd" ];
    then
        zellij run -fc --cwd "$2" -- "${@:3}"
    else
        zellij run -fc -- "$@"
    fi
else
    echo "Usage: zelij.sh <command>"
fi