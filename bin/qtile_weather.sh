#!/bin/sh

city=Brookeville
lat="39.180786987168126"
lon="-77.05892332232466"
format=2
if [ $(xrandr --current | awk 'BEGIN{s="normal"}/ primary /&&$5=="right"{s="right"}END{print s}') = right ]; then
  format=1
fi

weather=$(curl -sf wttr.in/$city?format=$format 2>&1)
ret=$?

if [ $ret != 0 ] || echo $weather | grep -q "Unknown location"; then
  if [ $format != 1 ]; then
    weather=$(curl -sf "https://forecast.weather.gov/MapClick.php?lat=$lat&lon=$lon" | awk -F '[><]' '/class=.myforecast-current.>/ {f=$3} /class=.myforecast-current-lrg.>/{t=gensub(/&deg;/, "°", "g", $3)} END{printf "%s %s",t,f}')
  else
    weather=$(curl -sf "https://forecast.weather.gov/MapClick.php?lat=$lat&lon=$lon" | awk -F '[><]' '/class=.myforecast-current-lrg.>/{t=gensub(/&deg;/, "°", "g", $3)} END{printf "%s",t}')
  fi
  if echo $weather | grep -q "°F" && [ $? = 0 ]; then
    printf "$weather"
  else
    printf "⌛"
  fi
else
  printf "$weather"
fi
