#!/usr/bin/env bash

if [[ -n "$1" ]]; then
  coproc ( rofi-sensible-terminal -e ssh "$1" & > /dev/null 2>&1 )
  exit
fi

hosts=()
host+=(sol)
host+=(mercury)
host+=(venus)
host+=(earth)
host+=(mars)
host+=(jupiter)
host+=(saturn)
#host+=(uranus)
host+=(neptune)
#host+=(pluto)

#host+=(luna)
host+=(carme)
host+=(metis)
host+=(tarvos)
host+=(sinope)
#host+=(styx)
#host+=(ersa)
host+=(dia)
host+=(homeassistant)
#host+=(dione)
#host+=(elara)
#host+=(thebe)
#host+=(carpo)
#host+=(ymir)

for host in "${host[@]}"; do
  echo -en " $host\0icon\x1futilities-terminal\n"
done
