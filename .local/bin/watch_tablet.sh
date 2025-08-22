#!/bin/sh

echo laptop > $XDG_RUNTIME_DIR/tablet_state
while true; do
  stdbuf -oL -eL libinput debug-events | \
  while read; do
    case "$REPLY" in
      *"switch tablet-mode state 0"|*"DEVICE_ADDED                 HID 1018:1006    "*)
        echo Switching to laptop
        echo laptop > $XDG_RUNTIME_DIR/tablet_state
        echo $REPLY >> $XDG_RUNTIME_DIR/tablet_state

        # disable onscreen keyboard
        gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false

        # wvtablet stuff
        #if pgrep -u $LOGNAME -f "wvkbd-(mobintl|tablet)" > /dev/null 2>&1; then
        #  pkill -u $LOGNAME -SIGUSR1 -f "wvkbd-(mobintl|tablet)"
        #else
        #  $HOME/bin/wvkbd-tablet -H 400 -L 300 --hidden &
        #fi

        pkill -u $LOGNAME -f ^nwg-dock-hyprland
        pkill -u $LOGNAME -f ^nwg-drawer
        cp -f $HOME/.config/local/hl_laptop.conf $HOME/.config/local/hl_mode.conf
        cp -f $HOME/.config/local/wb_laptop.jsonc $HOME/.config/local/wb_mode.jsonc
        pkill -u $LOGNAME -SIGUSR2 -x waybar
        ;;
      *"switch tablet-mode state 1"|*"DEVICE_REMOVED               HID 1018:1006    "*)
        echo Switching to tablet
        echo tablet > $XDG_RUNTIME_DIR/tablet_state
        echo $REPLY >> $XDG_RUNTIME_DIR/tablet_state

        # enable onscreen keyboard
        gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

        # wvtablet stuff
        #if pgrep -u $LOGNAME -f "wvkbd-(mobintl|tablet)" > /dev/null 2>&1; then
        #  pkill -u $LOGNAME -SIGUSR2 -f "wvkbd-(mobintl|tablet)"
        #else
        #  $HOME/bin/wvkbd-tablet -H 400 -L 300 &
        #fi

        cp -f $HOME/.config/local/hl_tablet.conf $HOME/.config/local/hl_mode.conf
        cp -f $HOME/.config/local/wb_tablet.jsonc $HOME/.config/local/wb_mode.jsonc
        pkill -u $LOGNAME -SIGUSR2 -x waybar
        [ -x $HOME/bin/run_nwg_dock ] && $HOME/bin/run_nwg_dock &
        ;;
    esac
  done
  sleep .5
done
