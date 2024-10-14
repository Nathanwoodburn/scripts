#!/bin/bash

# Copy file contents or command output to clipboard
# Usage: copy <file>
#        ... | copy
#
# Author: Nathan Woodburn

copy() {
    if tty -s; then
        file="$1"
        if [ -n "$file" ] && [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi

        xclip -selection clipboard < "$file"
    else
        xclip -selection clipboard
    fi
}

# Call the copy function with the provided arguments or from a pipe
if [ -t 0 ]; then
    copy "$@"
else
    copy
fi
