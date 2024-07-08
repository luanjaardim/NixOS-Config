#!/usr/bin/env bash

winds="main pfp time player sys_usg controls buttons slogan"
[ `eww ping` == "pong" ] || exit 1

[ $(eww get panel_visible) = "true" ] &&
eww close $winds && \
eww update panel_visible=false || (
eww open-many $winds && \
eww update panel_visible=true
)
