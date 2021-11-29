#!/bin/sh

mode=landscape
battery=🔋
charging=⚡
plug=🔌
computer=💻
mouse=🐭
crit=10
warn=20

while read -r; do
  [[ $REPLY =~ ^[0-9]+$ ]] && perc=$REPLY
done < /sys/class/power_supply/hidpp_battery_0/capacity

[ ! $perc ] && { printf "---"; exit 1; }

printf "%b" "$mouse $perc%"
