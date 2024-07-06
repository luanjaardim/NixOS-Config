#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 [up|down]"
    exit 1
elif [ "$1" == "up" ]; then
    brightnessctl set 300+
elif [ "$1" == "down" ]; then
    brightnessctl set 300-
fi
cur_bright=`brightnessctl get`
max_bright=`brightnessctl max`
val=$((cur_bright * 100 / max_bright))

notify-send -t 1000 -a "change Brightness" -u low -h string:x-dunst-stack-tag:"change brightness" \
  -h int:value:"$val" "Bright: ${val}" \
  -i $HOME/.config/dunst/imgs/bright.svg

exit 0
