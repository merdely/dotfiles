#!/bin/sh

if [ $(xrandr --current | awk 'BEGIN{s="normal"}/ primary /&&$5=="right"{s="right"}END{print s}') = right ]; then
  df -h / | awk 'NR==2{printf "💾%s", substr($5,1,length($5)-1) "%"}'
else
  df -h / | awk 'NR==2{printf "💾 %s/%s %s", $3, $2, substr($5,1,length($5)-1) "%"}'
fi
