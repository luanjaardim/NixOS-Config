#!/usr/bin/env bash

[ `eww ping` == "pong" ] || eww daemon &

# open windows from eww
eww open bar && rm $HOME/.config/eww/scripts/.bat_tmp # bat_tmp for battery script
