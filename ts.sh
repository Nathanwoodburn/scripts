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
    echo "Enabling node $2"
    tailscale set --exit-node="$2"
    exit 0
fi

echo "Usage: ts [list|en|en {node}]"
echo "List: Lists all nodes"
echo "EN: Exit node (clear)"
echo "EN {node}: Use node"
exit 1
