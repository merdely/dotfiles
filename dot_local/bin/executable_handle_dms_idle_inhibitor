#!/usr/bin/env bash

# To install in crontab, add:
# */15 * * * * $HOME/.local/bin/handle_dms_idle_inhibitor.sh

[ -r $HOME/.config/idle_inhibitor ] && . $HOME/.config/idle_inhibitor

! command -v dms &> /dev/null && echo "Error: ${0##*/} requires dms" >&2 && exit 1
! command -v notify-send &> /dev/null && echo "Warning: ${0##*/} requires notify-send to send messages" >&2 && exit 1

tmpfiles=()
trap 'rm -Rf "${tmpfiles[@]}"' EXIT
trap 'exit 1' INT TERM

calculate_check_seconds() {
  local result=${check_seconds:-$((4 * 60 * 60))}
  if [[ $hours =~ ^[1-9][0-9]*$ ]]; then
    result=$((hours * 60 * 60))
  elif [[ $seconds =~ ^[1-9][0-9]*$ ]]; then
    result=$seconds
  elif [[ $minutes =~ ^[1-9][0-9]*$ ]]; then
    result=$((minutes * 60))
  elif [[ $days =~ ^[1-9][0-9]*$ ]]; then
    result=$((days * 24 * 60 * 60))
  fi
  echo $result
}
pprint_time() {
  local def="$check_seconds seconds"
  if [ $(( check_seconds % 60 )) -eq 0 ]; then
    def="$((check_seconds / 60 )) minutes"
  fi
  if [ $(( check_seconds % (60 * 60) )) -eq 0 ]; then
    def="$((check_seconds / (60 * 60) )) hours"
  fi
  if [ $(( check_seconds % (24 * 60 * 60) )) -eq 0 ]; then
    def="$((check_seconds / (24 * 60 * 60) )) days"
  fi
  [[ $def == "1 "* ]] && def=${def%s}
  echo $def
}

[[ -n "$days" || -n "$hours" || -n "$minutes" || -n "$seconds" ]] && unset check_seconds
check_seconds=${check_seconds:-$(calculate_check_seconds)}

progname=${0##*/}
progname=${progname%.sh}
usage() {
  local def="$check_seconds seconds"
  if [ $(( check_seconds % 60 )) -eq 0 ]; then
    def="$((check_seconds / 60 )) minutes"
  fi
  if [ $(( check_seconds % (60 * 60) )) -eq 0 ]; then
    def="$((check_seconds / (60 * 60) )) hours"
  fi
  if [ $(( check_seconds % (24 * 60 * 60) )) -eq 0 ]; then
    def="$((check_seconds / (24 * 60 * 60) )) days"
  fi
  [[ $def == "1 "* ]] && def=${def%s}
  echo "usage: $progname [-h] [-i IDLE_FILE] [-d DAYS|-h HOURS|-m MINUTES|-s SECONDS]"
  echo "  -h           : This help text"
  echo "  -i IDLE_FILE : Use IDLE_FILE (default: $idle_file)"
  echo "  -d DAYS      : Use DAYS days to check for age of idle_file (default: $(pprint_time))"
  echo "  -h HOURS     : Use HOURS hours to check for age of idle_file (default: $(pprint_time))"
  echo "  -m MINUTES   : Use MINUTES minutes to check for age of idle_file (default: $(pprint_time))"
  echo "  -s SECONDS   : Use SECONDS seconds to check for age of idle_file (default: $(pprint_time))"
  exit $1
}

for a in $*; do [ $a = --help ] && usage; done
while getopts ":h:d:m:s:i:" opt; do
  case $opt in
    :) case $OPTARG in
         h) usage ;;
         *) echo "ERROR: -$OPTARG requires an argument" > /dev/stderr ; exit 1 ;;
       esac ;;
    i) case $OPTARG in
         -*) echo "Error: -$opt requires an argument" > /dev/stderr && exit 1 ;;
          *)
          idle_file_dir=$(realpath "$OPTARG")
          idle_file_dir=${idle_file_dir%/*}
          if [[ -w "$OPTARG" ]] || [[ -w "$idle_file_dir" ]]; then
            idle_file=$OPTARG
          else
            if [ ! -w "$idle_file_dir" ]; then
              echo "Error: Cannot write to $idle_file_dir" > /dev/stderr
            else
              echo "Error: Cannot write to $OPTARG" > /dev/stderr
            fi
            exit 1
          fi ;;
       esac ;;
    d)
      if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
        unset days hours minutes
        seconds=$((OPTARG * 24 * 60 * 60))
      else
        echo "Error: DAYS must be a number greater than one" > /dev/stderr
        exit 1
      fi ;;
    h)
      if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
        unset days hours minutes
        seconds=$((OPTARG * 60 * 60))
        hours=$OPTARG
      else
        echo "Error: HOURS must be a number greater than one" > /dev/stderr
        exit 1
      fi ;;
    m)
      if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
        unset days hours minutes
        seconds=$((OPTARG * 60))
      else
        echo "Error: MINUTES must be a number greater than one" > /dev/stderr
        exit 1
      fi ;;
    s)
      if [[ $OPTARG =~ ^[1-9][0-9]*$ ]]; then
        unset days hours minutes
        seconds=$OPTARG
      else
        echo "Error: SECONDS must be a number greater than one" > /dev/stderr
        exit 1
      fi ;;
    *) usage ;;
  esac
done
shift $((OPTIND - 1))

# Recalculate check seconds after parsing command line
check_seconds=$(calculate_check_seconds)

idle_file=${idle_file:=$XDG_CACHE_HOME/dms_idle_inhibited}

# If no idle_file exists, exit
[ ! -r "$idle_file" ] && exit 0

# Create tmpfile for time comparison and make it $hours old
tmpfile=$(mktemp)
tmpfiles+=("$tmpfile")
touch -d "$(pprint_time) ago" "$tmpfile"

# Compare idle_file with tmpfile to see if idle_file is older than $hours old
if test "$idle_file" -ot "$tmpfile"; then
  dms ipc call inhibit disable > /dev/null
  notify-send -a cron "Inhibit Idle Changed" "Idle Inhibitor Disabled Automatically after $(pprint_time)"
  rm -f "$idle_file"
fi

