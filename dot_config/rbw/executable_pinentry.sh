#!/bin/sh

case "$RBW_PINENTRY" in
  fuzzel) mode=fuzzel ;;
  rofi) mode=rofi ;;
  gtk) exec pinentry-gtk "$@" ;;
  gnome3) exec pinentry-gnome3 "$@" ;;
  qt) exec pinentry-qt "$@" ;;
  *) exec pinentry "$@" ;;
esac

# code borrowed from github.com/havvvsen/fuzzel-rbw
echo "OK"
while read -r cmd rest; do
  case "$cmd" in
    GETPIN|getpin)
      if [ "$mode" = fuzzel ]; then
        password=$(printf "" | fuzzel --mesg "Enter Bitwarden Password" --prompt-only "${rest:-> }" --password --dmenu)
      else
        password=$(printf "" | rofi -mesg "Enter Bitwarden Password" -p "${rest}" -password -dmenu -theme-str 'listview { enabled: false; } mainbox { children: ["message", "inputbar", "listview"]; }')
      fi
      if [ -z "$password" ]; then
        echo "ERR 83886179 User canceled"
      else
        echo "D $password"
        echo "OK"
      fi
      ;;
    BYE|bye)
      echo "OK"
      exit 0
      ;;
    *)
      echo "OK"
      ;;
  esac
done

