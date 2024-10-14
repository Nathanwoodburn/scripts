#!/bin/bash

# Check if first arg is colour
if [ "$1" = "colour" ]; then
    RED='%{F#ff0000}'
    GREEN='%{F#ff60d090}'
    YELLOW='%{F#ffff00}'
    BLUE='%{F#33fdfefe}'
    NC='%{F-}'
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
fi

# Check if Bluetooth is powered on
bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$bluetooth_status" == "yes" ]; then
    # Check if toggle is passed
    if [ "$#" -eq 1 ] && [ "$1" = "toggle" ]; then
        echo "Disabling Bluetooth"
        bluetoothctl power off
        exit 0
    fi

    # Check if any devices are connected
    connected_devices=$(bluetoothctl devices Connected | grep Device | cut -d ' ' -f 2)

    if [ -z "$connected_devices" ]; then
        # No devices connected, show disconnected icon
        echo -en "${GREEN}󰂯${NC}"
    else
        # Devices are connected, show connected icon
        echo -en "${GREEN}󰂱${NC}"

        # Loop through the connected devices
        for device in $connected_devices; do
            # Get the device info
            device_info=$(bluetoothctl info "$device")
            device_battery_percent=$(echo "$device_info" | grep "Battery Percentage" | awk -F'[()]' '{print $2}')
            device_battery_icon=""
            device_output=""
            device_name=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

            if [ -z "$device_name" ]; then
                device_name=$(echo "$device_info" | grep "Name" | cut -d ' ' -f 2-)
                if [ -z "$device_name" ]; then
                    device_name="Unknown Device"
                fi
            fi

            if [ -n "$device_battery_percent" ]; then
                if [ "$device_battery_percent" -gt 90 ]; then
                    device_battery_icon="${GREEN}"
                elif [ "$device_battery_percent" -gt 60 ]; then
                    device_battery_icon="${GREEN}"
                elif [ "$device_battery_percent" -gt 35 ]; then
                    device_battery_icon="${YELLOW}"
                elif [ "$device_battery_percent" -gt 15 ]; then
                    device_battery_icon="${YELLOW}"
                else
                    device_battery_icon="${RED}"
                fi
                device_output="$device_battery_icon $device_battery_percent%${NC}"
            fi

            # Print the device info
            echo -en " $device_name ($device_output)"
        done
    fi

else
    # Check if toggle is passed
    if [ "$#" -eq 1 ] && [ "$1" = "toggle" ]; then
        echo "Enabling Bluetooth"
        bluetoothctl power on
        exit 0
    fi
    echo -en "${RED}󰂲${NC}"
fi
