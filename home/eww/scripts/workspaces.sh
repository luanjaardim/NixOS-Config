#!/usr/bin/env sh

print_workspaces() {
    buf=""
    focused_desktop=$2
    occupied_desktops=$1

    for d in $(seq 1 5); do
        if [ "$d" == "$focused_desktop" ]; then
            ws="$d"
            icon=" "
            class="focused"
        elif [ -n "$(echo "$occupied_desktops" | rg "$d")" ]; then
            ws="$d"
            icon=" "
            class="occupied"
        else
            ws="$d"
            icon=" "
            class="empty"
        fi

        buf="$buf (eventbox :cursor \"hand\" \
            (button \
            :class \"$class\" \
            :onclick \"hyprctl dispatch workspace $ws\" \"$icon\"))"
    done

    echo "(box :class \"workspaces\"        \
                :space-evenly \"false\"     \
                :halign \"start\"            \
                $buf)"
}

print_workspaces "1" "1"
# Listen to hypr sock
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line
do
    update=false

    # Update the workspaces that have windows
    # and update the focused workspace
    if [ -n "$(echo $line | rg "movewindow>>")" ] \
       || [ -n "$(echo $line | rg "openwindow>>")" ] \
       || [ -n "$(echo $line | rg "closewindow>>")" ] \
       || [ -n "$(echo $line | rg "focusedmon>>")" ] \
       || [ -n "$(echo $line | rg "workspace>>")" ] \
       || [ -z "$occup_winds" ]
    then
        occup_winds="$(hyprctl clients -j | rg "\"id\":" | rg -o "\d")"
        activ_wind="$(hyprctl activewindow -j | rg "\"id\":" | rg -o "\d")"
        print_workspaces "$occup_winds" "$activ_wind"
    fi

    # Get the title from the activewindow and update title variable
    if [ -n "$(echo $line | rg "activewindow>>")" ]
    then
        name="$(echo $line | rg -o ">>.*,")"
        desc="$(echo $line | rg -o ",.*")"
        eww update program_name="${name:2:-1}"
        eww update program_desc="${desc:1}"
    fi

done

