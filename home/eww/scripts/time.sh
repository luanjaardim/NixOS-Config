#!/usr/bin/env bash

[ $(eww get time_hour) != $(date +%I) ] && eww update time_hour=$(date +%I)
[ $(eww get time_year) != $(date +%y) ] && eww update time_year=$(date +%y)
[ $(eww get time_mer) != $(date +%p) ] && eww update time_mer=$(date +%p)
[ $(eww get time_day) != $(date +%d) ] && eww update time_day=$(date +%d)
[ $(eww get time_month) != $(date +%m) ] && eww update time_month=$(date +%m)
[ $(eww get time_day_name) != $(date +%A) ] && eww update time_day_name=$(date +%A)
[ $(eww get time_month_name) != $(date +%B) ] && eww update time_month_name=$(date +%B)
echo $(date +%M)
