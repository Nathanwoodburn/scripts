#!/bin/bash

# Save logs to ~/.logs/zellij.log

# Check if focus on zellig window worked wmctrl -a zellij
if [ -z "$(wmctrl -l | grep Zellij)" ]; then
    echo "No terminal running" >/tmp/message
    echo "No terminal running" >>~/.logs/zellij.log
    polybar-msg action message hook 0
    exit 1
else
    wmctrl -a Zellij
    echo "Focused on terminal" >>~/.logs/zellij.log
fi

session=$(zellij list-sessions | grep -v "EXITED" | sed -r 's/\x1B\[[0-9;]*[mK]//g' | awk '{print $1}')

# For each line in the session list, echo to log
for line in $session; do
    echo "Found session: $line" >>~/.logs/zellij.log
    echo "Found session: $line"
    # Get arguments and run in new zellij pane
    if [ "$#" -ne 0 ]; then
        # Check if --cwd flag is passed
        if [ "$1" == "--cwd" ]; then
            echo "Using cwd: $2" >>~/.logs/zellij.log
            echo "Running command: ${@:3}" >>~/.logs/zellij.log

            zellij --session $line run -fc --cwd "$2" -- "${@:3}" >>~/.logs/zellij.log 2>&1
        else
            echo "Running command: $@" >>~/.logs/zellij.log
            zellij --session $line run -fc -- "$@" >>~/.logs/zellij.log 2>&1
        fi
    else
        echo "No command provided" >>~/.logs/zellij.log
        echo "Usage: zelij.sh <command>"
    fi
done