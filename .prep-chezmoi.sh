#!/bin/sh

[ -r /etc/os-release ] && . /etc/os-release

unset sys
case "$ID" in
  arch|artix|cachyos|garuda|endeavouros|manjaro) sys=arch ;;
esac
case "$ID_LIKE" in
  *arch*) sys=arch ;;
esac

if [ "$sys" = "arch" ]; then
  if [ "$LOGNAME" = "mike" ]; then
    if ! pacman -Q git > /dev/null 2>&1; then
      echo "Installing git"
      sudo pacman -Syu --needed --noconfirm git
    fi
  fi
fi

