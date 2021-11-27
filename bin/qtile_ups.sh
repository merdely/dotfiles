#!/bin/sh

if [ $(hostname -s) = mercury ]; then
out=$(upower -i $(upower -e|grep ups_hiddev) | awk '$1=="state:"{s="🔌⚡ ";if($2=="discharging")s="🔋 ";if($2=="fully-charged")s="🔌 "}$1=="percentage:" {printf "%s%s",s,$2}')
out=$(echo "$out" | sed 's/%/%%/g')
printf "$out" | grep -q --color=never "%" && printf "$out" || printf -- '---'
fi
