#!/usr/bin/env bash

progname=${0##*/}
progname=${progname%.sh}

export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
idle_file_default=${XDG_CACHE_HOME:-$HOME/.cache}/dms_idle_inhibited

case "$1" in
  onDankHooksStarted)
    # Handle either started or restarted
    if [ "$2" = started ] || [ "$2" = restarted ]; then
      # If Dank Inihibit Stats WAS enabled and dms restarted and the timeline has not been reached, re-enable
      [[ "$(dms ipc call inhibit status)" == *"is enabled" ]] && exit
      . ~/.config/idle_inhibitor
      t=$(mktemp)
      touch -d "${hours:=4} hours ago" $t
      test $idle_file -nt $t && { dms ipc call inhibit enable > /dev/null && \
        notify-send -a cron "Inhibit Idle Changed" "Idle Inhibitor enabled automatically after restart"; }
      rm -f $t
    fi

    # Handle just started
    if [ "$2" = started ]; then
      true
    fi

    # Handle just restarted
    if [ "$2" = restarted ]; then
      true
    fi
    ;;
  onInhibitorChanged)
    # If idle_inhibitor config exists, read it
    [ -r "${XDG_CONFIG_HOME:=$HOME/.config}/idle_inhibitor" ] && . "${XDG_CONFIG_HOME}"/idle_inhibitor
    # If idle_file is not set in config, set it to default ($idle_file_default)
    idle_file=${idle_file:=$idle_file_default}
    case "$2" in
      inhibited)
        touch "$idle_file"
        ;;
      not-inhibited)
        rm -f "$idle_file"
        ;;
      *)
        echo "Warning: $2 is an unsupported function for $1" >&2
        exit 1
        ;;
    esac
    ;;
  onSessionLocked)
    case "$2" in
      locked)
        dms ipc call inhibit disable
        screen-lock -L
        ;;
      *)
        echo "Warning: $2 is an unsupported function for $1" >&2
        exit 1
        ;;
    esac
    ;;
  onSessionUnlocked)
    case "$2" in
      unlocked)
        screen-unlock -L
        ;;
      *)
        echo "Warning: $2 is an unsupported function for $1" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo "Warning: $1 is an not a defined hook function" >&2
    exit 1
    ;;
esac

date "+%Y-%m-%d %H:%M:%S: $progname: $1: $2" >> ${XDG_RUNTIME_DIR:=/run/user/1000}/$progname.log
# notify-send -a $progname "$1 Changed" "$1 -> $2"

