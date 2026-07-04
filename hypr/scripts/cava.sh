#!/bin/bash
CONFIG_FILE="/tmp/waybarbar_cava_config"
trap "rm -f $CONFIG_FILE" EXIT

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"
i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i+1))
done

while true; do
    cat > "$CONFIG_FILE" << 'EOF'
[general]
bars = 20
framerate = 60
autosens = 1
sleep_timer = 1

[input]
method = pipewire
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

    cava -p "$CONFIG_FILE" 2>/dev/null | while read -r line; do
        if [[ "$line" =~ [1-7] ]]; then
            echo "$line" | sed "$dict"
        else
            echo ""
        fi
    done

    sleep 1
done
