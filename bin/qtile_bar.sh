#!/bin/bash

#date "+%F %T: $0 $*" >> /tmp/$(basename $0 .sh).log

# default variables
crit=10
warn=20
keyboardcrit=5
keyboardwarn=10
mousecrit=5
mousewarn=10
city=Brookeville
lat="39.180786987168126"
lon="-77.05892332232466"
background="#000000"
foreground="#ffffff"
unset debug dodraw mode separator screen_orientation

# icons
battery=🔋
charging=⚡
plug=🔌
computer=💻
disk=💾
mouse=🐭
keyboard=⌨
hourglass=⌛
brightness=🔅
bluecircle=🔵
greencircle=🟢
redsquare=🟥
locked=🔒
unlocked=🔑
greencheck=✅
redcross=❌
reduparrow=🔺
speakers=🔊
headphones=🎧

usage() {
  echo "usage: $0 [-h] [-d] [-q] [-l|-p] [-W WARN] [-C CRIT] [-f NUM] [-b NUM]"
  echo "                    [-s CHAR] [-c CITY] [-x COORD] [-y COORD] [widget]"
  echo "            -h      : This help text"
  echo "            -d      : Debug mode"
  echo "            -q      : 'qtile cmd-obj' mode"
  echo "            -l      : Landscape mode (default: detect)"
  echo "            -p      : Portrait mode (default: detect)"
  echo "            -W WARN : Warning threshold (default: $warn)"
  echo "            -C CRIT : Critical threshold (default: $crit)"
  echo "            -s CHAR : Print CHAR between widgets (default: none)"
  echo "            -c CITY : City (default: $city)"
  echo "            -x COORD: Longitude (default: $lon)"
  echo "            -y COORD: Latitude (default: $lat)"
  echo "            -b NUM  : Background color (default: $background)"
  echo "            -f NUM  : Foreground color (default: $foreground)"
  exit 0
}

while [ -n "$1" ]; do
  case $1 in
    -d) debug=1;;
    -b) shift;background=$1;;
    -f) shift;foreground=$1;;
    -l) screen_orientation=landscape;;
    -p) screen_orientation=portrait;;
    -x) shift;lon=$1;;
    -y) shift;lat=$1;;
    -c) shift;city=$1;;
    -s) shift;separator=$1;;
    -W) shift;warn=$1;;
    -C) shift;crit=$1;;
    -q) mode=qtile_cmd;;
    --help|-h|-\?) usage;;
    --) break;;
    -*) echo "Error: Invalid options"; usage;;
    *) break;;
  esac
  shift
done

[[ ! $warn =~ ^[0-9]+$ ]] && echo "Error: WARN must be a number ($warn)" && exit 0
[[ ! $crit =~ ^[0-9]+$ ]] && echo "Error: CRIT must be a number ($crit)" && exit 0
[[ ! $background =~ ^#?[0-9a-fA-F]{6}$ ]] && echo "Error: Background must be a hex color code ($background)" && exit 0
[[ ! $foreground =~ ^#?[0-9a-fA-F]{6}$ ]] && echo "Error: Background must be a hex color code ($foreground)" && exit 0

[ "${foreground:0:1}" != "#" ] && foreground="#$foreground"
[ "${background:0:1}" != "#" ] && background="#$background"

get_screen_orientation() {
  screen_orientation=$(xrandr --current --verbose|awk '/ primary /{print $6}')
  case $screen_orientation in
    left|right) screen_orientation=portrait;;
    *) screen_orientation=landscape;;
  esac
}

change_color() {
    [ $3 = $background ] && [ $2 = $foreground ] && return
    if [ $3 ]; then
      string="<span background=\"$3\">$string</span>"
    fi
    string="<span foreground=\"$2\">$string</span>"
}

widget_command() {
  [ "$mode" != qtile_cmd ] && return
  if [ $debug ]; then
    printf "   %b\n" "qtile cmd-obj -o widget $1 -f eval -a \"$2\""
  else
    qtile cmd-obj -o widget $1 -f eval -a "$2" > /dev/null
  fi
}

widget_output() {
  if [ "$mode" = qtile_cmd ]; then
    widget_command $widget "self.update('$*')"
  else
    printf "%b" "$*"
    [ $debug ] && printf "\n"
  fi
}

# Start processing widgets
if [ ! $1 ] || [ $1 = sshauth ]; then
  widget=sshauth
  [ $debug ] && printf "\n$widget:\n"
  if [ -r /run/user/$EUID/ssh-auth-sock ]; then
    env SSH_AUTH_SOCK=/run/user/$EUID/ssh-auth-sock ssh-add -l > /dev/null 2>&1
  else
    env SSH_AUTH_SOCK=$HOME/.ssh/ssh-auth-sock ssh-add -l > /dev/null 2>&1
  fi
  if [ $? = 0 ]; then
    string=$unlocked
  else
    string=$locked
  fi
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = xscreensaver ]; then
  widget=xscreensaver
  [ $debug ] && printf "\n$widget:\n"

  systemctl --user status xscreensaver.service > /dev/null 2>&1
  if [ $? = 0 ]; then
    string=$greencircle
  else
    string=$redsquare
  fi
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = brightness ]; then
  widget=brightness
  [ $debug ] && printf "\n$widget:\n"

  string=$(xrandr --prop --verbose|awk -vb=$brightness '$1=="Brightness:"{printf "%s %0.0f\n",b,$2*100;exit 0}')
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = battery ]; then
  widget=battery
  [ $debug ] && printf "\n$widget:\n"

  space=" "
  [ ! $screen_orientation ] && get_screen_orientation
  [ $screen_orientation != portrait ] && space=""
  eval $(upower -i $(upower -e|grep battery_BAT) | awk '$1=="state:"{print "state=" $2}$1=="percentage:" {print "perc=" substr($2,1,length($2)-1)}')
  [[ ! $perc =~ ^[0-9]+$ ]] || [ ! $state ] && { widget_output "$battery$space---"; exit 0; }

  string="$perc%"
  ischarging=0
  case $state in
    discharging|Discharging) string="$battery$space$string";;
    fully-charged|Full) string="$plug$space$string";;
    *)
      ischarging=1
      # https://jkorpela.fi/chars/spaces.html
      # Zero width space: U+200B
      string="$charging$space$string"
      [ $screen_orientation != portrait ] && string="$plug​$string"
      ;;
  esac

  [ ${HOSTNAME:=notmercury} = mercury ] && string="$string $computer"

  if ((perc <= crit)) && [ $ischarging = 0 ]; then
    change_color $widget "#ffffff" "#ff0000"
  elif ((perc > crit)) && ((perc <= warn)) && [ $ischarging = 0 ]; then
    change_color $widget "#000000" "#ffff00"
  else
    change_color $widget $foreground $background
  fi
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = ups ]; then
  widget=ups
  [ $debug ] && printf "\n$widget:\n"

  space=" "
  [ ! $screen_orientation ] && get_screen_orientation
  eval $(upower -i $(upower -e|grep ups_hiddev) | awk '$1=="state:"{print "state=" $2}$1=="percentage:" {print "perc=" substr($2,1,length($2)-1)}')
  [[ ! $perc =~ ^[0-9]+$ ]] || [ ! $state ] && { widget_output "$battery ---"; exit 0; }

  string="$perc%"
  ischarging=0
  case $state in
    discharging|Discharging) string="$battery$space$string";;
    fully-charged|Full) string="$plug$space$string";;
    *)
      ischarging=1
      # https://jkorpela.fi/chars/spaces.html
      # Zero width space: U+200B
      string="$charging$space$string"
      [ $screen_orientation != portrait ] && string="$plug​$string"
      ;;
  esac

  if ((perc <= crit)) && [ $ischarging = 0 ]; then
    change_color $widget "#ffffff" "#ff0000"
  elif ((perc > crit)) && ((perc <= warn)) && [ $ischarging = 0 ]; then
    change_color $widget "#000000" "#ffff00"
  else
    change_color $widget $foreground $background
  fi
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = mousebatt ]; then
  widget=mousebatt
  [ $debug ] && printf "\n$widget:\n"

  eval $(upower -i $(upower -e|grep mouse_hidpp_battery) | awk '$1=="state:"{print "state=" $2}$1=="percentage:" {print "perc=" substr($2,1,length($2)-1)}')
  [[ ! $perc =~ ^[0-9]+$ ]] || [ ! $state ] && { widget_output "$mouse ---"; exit 0; }

  string="$mouse $perc%"
  ischarging=0
  charge_icon=" "
  [[ $state = charging ]] && ischarging=1 && charge_icon=" $charging"
  ischarging=0

  if ((perc <= mousecrit)) && [ $ischarging = 0 ]; then
    change_color $widget "#ffffff" "#ff0000"
  elif ((perc > mousecrit)) && ((perc <= mousewarn)) && [ $ischarging = 0 ]; then
    change_color $widget "#000000" "#ffff00"
  else
    change_color $widget $foreground $background
  fi

  widget_output "$string$charge_icon"
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = keyboardbatt ]; then
  widget=keyboardbatt
  [ $debug ] && printf "\n$widget:\n"

  eval $(solaar show "G915 WIRELESS RGB MECHANICAL GAMING KEYBOARD" | awk '$1=="Battery:"{printf "state=%s\nperc=%s\n",substr($(NF-1),1,length($(NF-1))-1),substr($NF,1,length($NF)-1);exit}')
  [[ ! $perc =~ ^[0-9]+$ ]] || [ ! $state ] && { widget_output "$keyboard ---"; exit 0; }

  string="$keyboard $perc%"
  ischarging=0
  charge_icon=" "
  [[ $state = recharging ]] && ischarging=1 && charge_icon=" $charging"

  if ((perc <= keyboardcrit)) && [ $ischarging = 0 ]; then
    change_color $widget "#ffffff" "#ff0000"
  elif ((perc > keyboardcrit)) && ((perc <= keyboardwarn)) && [ $ischarging = 0 ]; then
    change_color $widget "#000000" "#ffff00"
  else
    change_color $widget $foreground $background
  fi

  widget_output "$string$charge_icon"
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = df ]; then
  widget=df
  [ $debug ] && printf "\n$widget:\n"

  eval $(df -h / | awk 'NR==2{printf "size=%s;used=%s;usep=%s\n",$2,$3,substr($5,1,length($5)-1)}')
  [ ! $screen_orientation ] && get_screen_orientation
  if [ $screen_orientation = portrait ]; then
    string="$disk$usep%U"
  else
    string="$disk $used/$size $usep%U"
  fi
  if ((usep >= 100-crit)); then
    change_color $widget "#ffffff" "#ff0000"
  elif ((usep >= 100-warn)) && ((usep < 100-crit)); then
    change_color $widget "#000000" "#ffff00"
  else
    change_color $widget $foreground $background
  fi
  widget_output "$string"
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = weather ]; then
  widget=weather
  [ $debug ] && printf "\n$widget:\n"

  format=2
  [ ! $screen_orientation ] && get_screen_orientation
  [ $screen_orientation = portrait ] && format=1

  string=$(curl -sf wttr.in/$city?format=$format 2>&1)
  ret=$?

  if [ $ret != 0 ] || echo $string | grep -q "Unknown location"; then
    if [ $format != 1 ]; then
      string=$(curl -sf "https://forecast.weather.gov/MapClick.php?lat=$lat&lon=$lon" | awk -F '[><]' '/class=.myforecast-current.>/ {f=$3} /class=.myforecast-current-lrg.>/{t=gensub(/&deg;/, "°", "g", $3)} END{printf "%s %s",t,f}')
      newret=$?
    else
      string=$(curl -sf "https://forecast.weather.gov/MapClick.php?lat=$lat&lon=$lon" | awk -F '[><]' '/class=.myforecast-current-lrg.>/{t=gensub(/&deg;/, "°", "g", $3)} END{printf "%s",t}')
      newret=$?
    fi
    if ! echo $string | grep -q "°F" || [ $newret != 0 ]; then
      string=$hourglass
    fi
  fi
  widget_output $string
fi

[ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ! $1 ] || [ $1 = updates ]; then
  widget=updates
  [ $debug ] && printf "\n$widget:\n"

  [ "$2" = force ] && sudo /srv/scripts/sbin/pacman_update_count > /dev/null

  if [ -r /run/pacman_updates ]; then
    string=$reduparrow
  else
    string=$greencheck
  fi
  widget_output $string
fi

[ ${HOSTNAME:=notmercury} = mercury ] && [ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ${HOSTNAME:=notmercury} = mercury ] && [[ ! $1  || $1 = audio_output ]]; then
  widget=audio_output
  [ $debug ] && printf "\n$widget:\n"

  default_sink=$(pactl get-default-sink)
  if [[ $default_sink = *usb-Google_Inc_Headphone_adapter* ]]; then
    string=$headphones
  elif [[ $default_sink = *bluez_sink* ]]; then
    string=$bluecircle
  else
    string=$speakers
  fi
  widget_output $string
fi

[ ${HOSTNAME:=notmercury} != mercury ] && [ ! $1 ] && [ $separator ] && printf " %b " "$separator"

if [ ${HOSTNAME:=notmercury} != mercury ] && [[ ! $1  || $1 = clock ]]; then
  widget=clock
  [ $debug ] && printf "\n$widget:\n"

  [ ! $screen_orientation ] && get_screen_orientation
  if [ $screen_orientation = portrait ]; then
    printf -v string '%(%-I:%M%P)T' -1
  else
    printf -v string '%(%a %-m/%-d, %-I:%M%P)T' -1
  fi
  widget_output $string
fi

[ $dodraw ] && widget_command $1 "self.draw()"
exit 0
