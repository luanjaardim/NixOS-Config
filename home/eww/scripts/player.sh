#!/bin/bash

pctl="playerctl --player=spotify,%any metadata --format "
if [ "$1" == "info" ]; then
    echo `$pctl '{{artist}} - {{title}}'`

elif [ "$1" == "pos" ]; then
    echo `$pctl '{{position}}'`

elif [ "$1" == "len" ]; then
    echo `$pctl '{{mpris:length}}'`

elif [ "$1" == "status" ]; then
    echo `$pctl '{{status}}' | grep -q 'Paused' && echo true || echo false`

else
    echo "Invalid argument"
    exit 1
fi

exit 0
