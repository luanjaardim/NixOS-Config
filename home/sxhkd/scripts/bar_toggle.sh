#!/usr/bin/env nix-shell
#! nix-shell -i bash

bar_state="$(dirname $0)/.bar_tog_tmp"

([ `eww get bar_visible` = "true" ] \
&& eww update bar_visible=false \
&& eww close bar \
&& bspc config top_padding 1 \
&& notify-send "Bar hidden" -t 1000) || (
eww update bar_visible=true \
&& eww open bar \
&& bspc config top_padding 50 \
&& notify-send "Bar shown" -t 1000)

