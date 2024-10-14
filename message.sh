#!/bin/bash

message() {
    if tty -s; then
        echo "$1" >/tmp/message
    else
        # Get from pipe
        cat >/tmp/message
    fi
    output=$(polybar-msg action message hook 0)
    # Check if the output contains Successfully
    if [[ $output == *"Successfully"* ]]; then
        echo "Message sent successfully"
    else
        echo "Error sending message"
    fi
}

# Call the copy function with the provided arguments or from a pipe
if [ -t 0 ]; then
    message "$@"
else
    message
fi
