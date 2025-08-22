#!/bin/sh

choices() {
  for f in $@; do
    #echo $f
    echo "$(playerctl -p "$f" metadata artist) - $(playerctl -p "$f" metadata title) on $f"
  done
}
if playerctl -a status | grep -q Playing; then
  playerctl -a pause
else
  list=$(playerctl -l)
  if [[ $(echo "$list" | wc -l) -gt 1 ]]; then
    IFS=$(printf '\n\b')
    choice=$(choices $list | sort | rofi -dmenu)
    player=$(echo $choice | awk '{print $NF}')
    playerctl -p $player play
  else
    playerctl play
  fi
fi
