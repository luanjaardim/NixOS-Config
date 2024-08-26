#!/usr/bin/env nix-shell
#!nix-shell -i bash -p libnotify pulseaudio ripgrep

# Op used to microphone or speaker
case "$1" in
	"micro") device="source" ;;
	"speaker") device="sink" ;;
	*) echo "Options for the first argument: micro, speaker"; exit 1 ;;
esac
# Get, Set or mute/unmute
case "$2" in
	"get") op="get-$device-volume" ;;
	"set") op="set-$device-volume" ;;
	"toggle") op="set-$device-mute" ;;
	*) echo "Options for the second argument: get, set, toggle"; exit 1 ;;
esac

[ "$2" == "set" ] && [ -z "$3" ] && echo "Expected a value to set as third argument." && exit 1

device_captalized="$(echo $device | tr "[:lower:]" "[:upper:]")"
default_dev="@DEFAULT_${device_captalized}@"

if [ "$2" == "get" ]; then
	pactl $op $default_dev | rg -o '\d+%' | head -n 1 | tr -d '%'
else
	value="$([ "$2" == "toggle" ] && echo "toggle" || echo "$3")"
	pactl $op $default_dev $value
fi

