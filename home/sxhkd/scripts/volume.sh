#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 [up|down]"
    exit 1
elif [ "$1" == "up" ]; then
    # pactl set-sink-volume @DEFAULT_SINK@ +2%
    amixer -q set Master 2%+
elif [ "$1" == "down" ]; then
    amixer -q set Master 2%-
fi

volume=`amixer get Master | grep -oP '\\d+%' | head -n1 | tr -d '%'`
notify-send -t 1000 -a "change Volume" -u low -h string:x-dunst-stack-tag:"change volume" \
  -h int:value:"$volume" "Volume: ${volume}" \
  -i $HOME/.config/dunst/imgs/volume.svg
