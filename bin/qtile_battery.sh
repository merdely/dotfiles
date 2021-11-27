#!/bin/sh

compicon=" 💻"
plugicon="🔌"
[ $(hostname -s) != mercury ] && unset compicon plugicon

if [ $(xrandr --current | awk 'BEGIN{s="normal"}/ primary /&&$5=="right"{s="right"}END{print s}') = right ]; then
  upower -i $(upower -e|grep battery_BAT) | awk '$1=="state:"{s="⚡";if($2=="discharging")s="🔋";if($2=="fully-charged")s="🔌"}$1=="percentage:" {printf "%s%s",s,$2}' # | grep --color=never % || printf '---'
else
  upower -i $(upower -e|grep battery_BAT) | awk -v c="$compicon" -v p="$plugicon" '$1=="state:"{s=p "⚡ ";if($2=="discharging")s="🔋 ";if($2=="fully-charged")s=p " "}$1=="percentage:" {printf "%s%s%s",s,$2,c}' # | grep --color=never % || printf '---'
fi
