#!/bin/sh

[ -r /etc/os-release ] && source /etc/os-release

unset sys
case "$ID" in
  arch|artix|cachyos|garuda|endeavouros|manjaro) sys=arch ;;
esac
case "$ID_LIKE" in
  *arch*) sys=arch ;;
esac

if [ "$sys" = "arch" ]; then
  sudo pacman -Syu --needed pass git gnupg
fi

