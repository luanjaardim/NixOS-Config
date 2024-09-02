#!/usr/bin/env bash

# This script is used to check the battery status of the laptop
# returnig the battery percentage and notifying the user if the battery is low or full

battery_level=`acpi -b | grep -oP '\\d+%' | tr -d '%'`
battery_status=`acpi -b | grep -oP 'Charging|Discharging'`
path_to_icon=$HOME/.config/dunst/imgs/
script_path=$HOME/.config/eww/scripts/

if [ $battery_status == "Charging" ] && [ "$(eww get isCharging)" == "false" ]
then
    eww update isCharging=true
    # notify-send -u normal "is charging? $(eww get isCharging)"
    dunstctl close-all
    notify-send -u normal "Batery is charging!" "Battery level is ${battery_level}%!" \
    -h string:frcolor:#33D17A \
    -i $path_to_icon/charging_bat.svg \
    -t 2000

elif [ $battery_level -le 20 ] && [ $battery_status == "Discharging" ]
then
    notify-send -u critical "Battery low!" "Battery level is ${battery_level}%!" \
    -i $path_to_icon/low_bat.svg # change the icon of the notification

elif [ $battery_level -eq 100 ]
then

    notify-send -u normal "Battery full!" "Battery level is ${battery_level}%!" \
    -h string:frcolor:#838FE9 \
    -i $path_to_icon/full_bat.svg
    # change the frame color of the notification
    # change the icon of the notification

elif [ $battery_status == "Discharging" ] && [ "$(eww get isCharging)" == "true" ]
then
    # notify-send -u normal "is discharging? $(eww get isCharging)"
    eww update isCharging=false
    notify-send -u normal "Batery is discharging!" "Battery level is ${battery_level}%!" \
    -t 2000

fi

# return the battery percentage
echo $battery_level

exit 0
