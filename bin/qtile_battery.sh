#!/bin/sh

mode=landscape
battery=🔋
charging=⚡
plug=🔌
computer=💻
crit=10
warn=20

[ "$1" = "-h" ] && echo "usage: $(basename $0) [-h] -c|-w|-o" && echo "       -c: critical, -w: warning, -o: ok" && exit

# This is only needed for mercury because it has a UPS
[ $(hostname -s) != mercury ] && unset computer

for batt in /sys/class/power_supply/BAT*; do
  [ ! -r $batt/capacity -o ! -r $batt/status ] && continue
  while read -r; do
    [[ $REPLY =~ ^[0-9]+$ ]] && perc=$REPLY
  done < $batt/capacity
  while read -r; do
    state=$REPLY
  done < $batt/status
  [ $perc ] && [ $state ] && break
done
[ ! $perc ] || [ ! $state ] && { printf "---"; exit 1; }

screen=$(xrandr --current | awk 'BEGIN{s="normal"}/ primary /&&$5=="right"{s="right"}END{print s}')
[ $screen = right -o $screen = left ] && mode=portrait

case $state in
  Discharging)
    s=$battery
    ;;
  Full)
    s=$plug
    ;;
  *)
    # https://jkorpela.fi/chars/spaces.html
    # Zero width space: U+200B
    s="$plug​$charging"
    [ $mode = portrait ] && s=$charging
    ;;
esac

if [ $mode = portrait ]; then
  string="$s$perc%"
else
  string="$s $perc% $computer"
fi

case "$1" in
  -c) lower=0; upper=$crit ;;
  -w) lower=$crit; upper=$warn ;;
   *) lower=$warn; upper=101 ;;
esac

if ((perc > lower)) && ((perc <= upper)); then
  printf "%b" "$string"
fi
