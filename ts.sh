#!/bin/bash

# Usage: ts [list|en|en {node}]
# List: Lists all nodes
# EN: Exit node (clear)
# EN {node}: Use node

if [ "$#" -eq 0 ]; then
    echo "Usage: ts [list|en|en {node}]"
    echo "List: Lists all nodes"
    echo "EN: Exit node (clear)"
    echo "EN {node}: Use node"
    echo "Short: List info short"
    exit 1
fi

if [ "$1" = "list" ]; then
    tailscale status
    exit 0
fi

if [ "$1" = "en" ]; then
    if [ "$#" -eq 1 ]; then
        echo "Clearing exit node"
        tailscale set --exit-node=
        exit 0
    fi
    if [ "$2" = "toggle" ]; then
        output=$(tailscale status | grep "; exit node;")
        hostname=$(echo "$output" | awk '{print $2}')
        # Check if node is exit node
        if [ -z "$hostname" ]; then
            tailscale set --exit-node=docker01
        else
            tailscale set --exit-node=
        fi
        exit 0
    fi

    echo "Enabling node $2"
    tailscale set --exit-node="$2"
    exit 0
fi
if [ "$1" = "short" ]; then
    # Check if a third arg is sent
    if [ -z "$2" ]; then
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[0;33m'
        BLUE='\033[0;34m'
        NC='\033[0m' # No Color
    else
        RED='%{F#ff0000}'
        GREEN='%{F#ff60d090}'
        YELLOW='%{F#ffff00}'
        BLUE='%{F#0000ff}'
        NC='%{F-}'
    fi

    # Check if connected
    output=$(tailscale status)
    if [[ "$output" == *"stopped"* ]]; then
        echo -e "${RED}󰦞${NC}"
        exit 0
    fi
    # Get line for nwtux
    device=$(echo "$output" | grep "nwtux")
    if [[ "$device" == *"offline"* ]]; then
        echo -e "${RED}󰦞${NC}"
        exit 0
    fi
        
    output=$(tailscale status | grep "; exit node;")
    hostname=$(echo "$output" | awk '{print $2}')
    # Check if node is exit node
    if [ -z "$hostname" ]; then
        echo -e "${GREEN}󰕥${NC}"
        exit 0
    fi
    echo -e "${BLUE}󰻌${NC} $hostname"
    exit 0
fi

echo "Usage: ts [list|en|en {node}]"
echo "List: Lists all nodes"
echo "EN: Exit node (clear)"
echo "EN {node}: Use node"
echo "Short: List info short"
exit 1
