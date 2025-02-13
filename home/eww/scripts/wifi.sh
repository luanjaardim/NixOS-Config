#!/usr/bin/env bash

symbol() {
    [ $(cat /sys/class/net/w*/operstate) = down ] && echo 󰤭  && exit
    echo 󰤨
}

name() {
  iwgetid -r
}

[ "$1" = "icon" ] && symbol

if [[ $1 == "name" || $1 == "class" ]]; then
  wifiname=$(name)
  if [[ $wifiname == "" ]]; then
    if [[ $1 == "name" ]]; then
      echo "Disconnected"
    elif [[ $1 == "class" ]]; then
      echo "disconnected"
    fi
  else
    if [[ $1 == "name" ]]; then
      echo "Connected to $wifiname"
    elif [[ $1 == "class" ]]; then
      echo "connected"
    fi
  fi
fi
