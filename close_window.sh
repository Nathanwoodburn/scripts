#!/bin/bash

window_id=$(xdotool getwindowfocus)
# xdotool windowclose $window_id
xdotool windowactivate --sync $window_id key --clearmodifiers --delay 100 alt+F4