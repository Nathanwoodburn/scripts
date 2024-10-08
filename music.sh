#!/bin/bash

# Maximum title length
MAX_TITLE_LENGTH=20
MAX_ARTIST_LENGTH=20

verbose=0

# Check if any argument is passed
if [ "$#" -ne 0 ]; then
    arg="$1"
    if [ "$arg" == "play" ]; then
        playerctl play
    elif [ "$arg" == "pause" ]; then
        playerctl pause
    elif [ "$arg" == "next" ]; then
        playerctl next
    elif [ "$arg" == "prev" ]; then
        playerctl previous
    elif [ "$arg" == "verbose" ]; then
        verbose=1
    else
        echo "Invalid argument. Please use one of the following: play, pause, next, prev"
        exit 0
    fi
    if [ "$#" -eq 2 ]; then
        if [ "$2" == "verbose" ]; then
            verbose=1
        fi
    fi    
fi


# Check if playerctl is available
if ! command -v playerctl &> /dev/null; then
    echo "playerctl is not installed. Please install it to use this script."
    exit 1
fi

# Get all player names and statuses
players=$(playerctl -a -l)
active_players=()
brave=""

# Loop through each player and check its status
for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    # Check if player name contains brave
    if [[ "$player" == *"brave"* ]]; then
        brave=$player
        continue
    fi

    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        active_players+=("$player:$status")
    fi
done

# Function to truncate a string to a certain length
truncate_string() {
    local string="$1"
    local max_length="$2"
    if [ ${#string} -gt $max_length ]; then
        echo "${string:0:$max_length}..."
    else
        echo "$string"
    fi
}

# Check how many active players we found
active_count=${#active_players[@]}

if [ "$active_count" -eq 1 ]; then
    # If exactly one player is active, print its metadata
    IFS=":" read -r player status <<< "${active_players[0]}"
    title=$(playerctl -p "$player" metadata --format '{{title}}')
    # If title == Vilos Player, get the title from the brave player
    if [ "$title" == "Vilos" ]; then
        title=$(playerctl -p "$brave" metadata --format '{{title}}')
        truncated_title=$(truncate_string "$title" $(($MAX_TITLE_LENGTH+$MAX_ARTIST_LENGTH)))
        if [ "$status" == "Paused" ]; then
            echo "🎵 $truncated_title (Paused)"
        else
            echo "🎵 $truncated_title"
        fi
        exit 0
    fi
    artist=$(playerctl -p "$player" metadata --format '{{artist}}')
    truncated_title=$(truncate_string "$title" $MAX_TITLE_LENGTH)
    truncated_artist=$(truncate_string "$artist" $MAX_ARTIST_LENGTH)

    if [ "$status" == "Paused" ]; then
        echo "🎵 $truncated_title [$truncated_artist] (Paused)"
    else
        echo "🎵 $truncated_title [$truncated_artist]"
    fi
    
elif [ "$active_count" -gt 1 ]; then
    # Count to see how many playing players there are
    playing_count=0
    output=""

    for player in "${active_players[@]}"; do
        IFS=":" read -r player status <<< "$player"
        if [ "$status" == "Playing" ]; then
            playing_count=$((playing_count + 1))
            title=$(playerctl -p "$player" metadata --format '{{title}}')
            if [ "$title" == "Vilos" ]; then
                title=$(playerctl -p "$brave" metadata --format '{{title}}')
                truncated_title=$(truncate_string "$title" $(($MAX_TITLE_LENGTH+$MAX_ARTIST_LENGTH)))
                output+="🎵 $truncated_title"
            else
                artist=$(playerctl -p "$player" metadata --format '{{artist}}')
                truncated_title=$(truncate_string "$title" $MAX_TITLE_LENGTH)
                truncated_artist=$(truncate_string "$artist" $MAX_ARTIST_LENGTH)
                output+="🎵 $truncated_title [$truncated_artist]"
            fi
        fi
    done
    if [ "$playing_count" -eq 1 ]; then
        echo "$output"
    else
        echo "Multiple players playing"
        if [ "$verbose" -eq 1 ]; then
            for player in "${active_players[@]}"; do
                IFS=":" read -r player status <<< "$player"
                title=$(playerctl -p "$player" metadata --format '{{title}}')
                artist=$(playerctl -p "$player" metadata --format '{{artist}}')
                echo "$player: $title - $artist"
                echo "Status: $status"
            done
        fi
    fi
    
fi
