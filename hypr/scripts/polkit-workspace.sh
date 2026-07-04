#!/bin/bash

# Listen for auth dialog windows and move them to the current workspace

HYPRLAND_SOCKET="$XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if [[ ! -S "$HYPRLAND_SOCKET" ]]; then
    echo "Hyprland socket not found"
    exit 1
fi

# Connect to Hyprland event socket
socat -U - UNIX-CONNECT:"$HYPRLAND_SOCKET" | while read -r line; do
    if [[ "$line" =~ ^window>> ]]; then
        event_data="${line#window>>}"
        event_type="${event_data%%>>*}"
        window_addr="${event_data#*>>}"
        window_addr="${window_addr%%,*}"
        
        if [[ "$event_type" == "open" ]]; then
            # Get window info
            window_info=$(hyprctl clients -j | python3 -c "
import json, sys
clients = json.load(sys.stdin)
addr = '$window_addr'
for c in clients:
    if c.get('address', '').lower() == addr.lower():
        title = c.get('title', '')
        if 'Authentication' in title or 'authent' in title.lower() or 'password' in title.lower():
            print('match')
")
            if [[ "$window_info" == "match" ]]; then
                current_ws=$(hyprctl activeworkspace -j | python3 -c "import json,sys;print(json.load(sys.stdin)['id'])")
                hyprctl dispatch movetoworkspace "$current_ws",address:"$window_addr"
            fi
        fi
    fi
done
