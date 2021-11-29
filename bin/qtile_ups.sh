#!/bin/sh

mode=landscape
battery=🔋
charging=⚡
plug=🔌
computer=💻
crit=10
warn=20

[ "$1" = "-h" ] && echo "usage: $(basename $0) [-h] -c|-w|-o" && echo "       -c: critical, -w: warning, -o: ok" && exit

eval $(upower -i $(upower -e|grep ups_hiddev) | awk '$1=="state:"{print "state=" $2}$1=="percentage:" {print "perc=" substr($2,1,length($2)-1)}')

[[ ! $perc =~ ^[0-9]+$ ]] || [ ! $state ] && { printf "---"; exit 1; }

case $state in
  discharging)
    s=$battery
    ;;
  fully-charged)
    s=$plug
    ;;
  *)
    # https://jkorpela.fi/chars/spaces.html
    # Zero width space: U+200B
    s="$plug​$charging"
    [ $mode = portrait ] && s=$charging
    ;;
esac

string="$s $perc%"

case "$1" in
  -c) lower=0; upper=$crit ;;
  -w) lower=$crit; upper=$warn ;;
   *) lower=$warn; upper=101 ;;
esac

if ((perc > lower)) && ((perc <= upper)); then
  printf "%b" "$string"
fi

