#!/usr/bin/env bash

# This script is used to update music variables
info=$(./scripts/player.sh info)
[ "$(eww get music_info)" != "$info" ] && eww update music_info="$info"
len=$(./scripts/player.sh len)
[ "$(eww get music_length)" != "$len" ] && eww update music_length="$len"
paused=$(./scripts/player.sh status)
[ "$(eww get music_paused)" != "$paused" ] && eww update music_paused="$paused"
echo $(./scripts/player.sh pos)
