#!/bin/bash

# Package to hold
PACKAGE=$1

if [ -z "$PACKAGE" ]; then
  echo "Usage: hold <package_name>"
  echo "Set or unset a package on hold"
  exit 1
fi

# Check to see if the package is already on hold using apt-mark showhold
if ! apt-mark showhold | grep -q "$PACKAGE"; then
  sudo apt-mark hold $PACKAGE
else
  echo "$PACKAGE is already on hold unholding..."
  sudo apt-mark unhold $PACKAGE
fi