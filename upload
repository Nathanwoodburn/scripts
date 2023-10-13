#!/bin/bash

# Upload a file or directory to the internet and display the URL in the terminal
# Usage: upload <file|directory>
#        ... | upload <file_name>
#
# Author: Nathan Woodburn


upload() {
    if [ $# -eq 0 ]; then
        echo "No arguments specified."
        echo "Usage: upload <file|directory>"
        echo "... | upload <file_name>" >&2
        return 1
    fi

    if tty -s; then
        file="$1"
        file_name=$(basename "$file")

        if [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi

        if [ -d "$file" ]; then
            file_name="$file_name.zip"
            url=$( (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file - "https://upload.woodburn.au/$file_name" | tee /dev/null)
        else
            url=$(cat "$file" | curl --progress-bar --upload-file - "https://upload.woodburn.au/$file_name" | tee /dev/null)
        fi

        # Generate and display the QR code for the URL in the terminal

	echo -e "\n\n"
    qrencode -t utf8 "$url"
	echo -e "\n"
	echo "$url"
	echo -e "\n"

    else
        file_name=$1
        url="https://upload.woodburn.au/$file_name"
        echo -n "$url" | curl --progress-bar --upload-file - "$url" | tee /dev/null
    fi
}

# Call the upload function with the provided arguments
upload "$@"
