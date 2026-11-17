#!/bin/bash

# Wait briefly for the display handshake or disconnect to settle
sleep 2

# Check if any external DisplayPort/HDMI connector is connected
if grep -q "^connected$" /sys/class/drm/card*-DP-*/status 2>/dev/null; then
 
    # DOCKED: Switch to Desktop Mode if currently in Gaming Mode
    if pgrep -x "gamescope-session" > /dev/null; then
        # check if plasma using wayland or x11
        su - deck -c "DISPLAY=:0 /usr/bin/steamos-session-select plasma-wayland-persistent" 2>/dev/null || \
        su - deck -c "DISPLAY=:0 /usr/bin/steamos-session-select plasma-x11-persistent"
    fi
else
    # UNDOCKED: Switch back to Gaming Mode if currently in Desktop Mode
    if pgrep -x "plasmashell" > /dev/null; then
        su - deck -c "DISPLAY=:0 /usr/bin/steamos-session-select gamescope"
    fi
fi