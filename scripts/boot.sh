#!/usr/bin/env bash

# Set mouse deecleration
xinput --set-prop "Logitech M505/B605" "Device Accel Constant Deceleration" 0.4

# Set caps lock to escape
xmodmap -e 'clear Lock' -e 'keysym Caps_Lock = Escape'
