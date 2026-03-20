##############################################################
## get_config_value function definition

get_config_value() {
  # No section: variable=$(get_config_value file key)
  # Section:    variable=$(get_config_value file section key)
  [ -z "$2" ] && return 1
  local r=$1 s="" k=$2
  [ -n "$3" ] && s=$2 && k=$3
  if [ ! -r "$r" ]; then
    ${debug:-false} && echo "Warning: Cannot read ${r##*/} for ${s:+[$s] }$k" > /dev/stderr
    return 1
  fi
  if [ -n "$s" ]; then
    awk -vs="$s" -vk="$k" 'BEGIN{p=0}$0~/^[[:space:]]*\[/{p=0}$0~"^[[:space:]]*\\["s"\\]"{p=1}p==1&&$0~"^[[:space:]]*"k"[[:space:]]*[:=]"{sub(/^[^:=]+[:=][[:space:]]*/,"");sub(/[[:space:]]+$/,"");print;exit}' "$r"
  else
    awk -vk="$k" '$0~"^[[:space:]]*"k"[[:space:]]*[:=]"{sub(/^[^:=]+[:=][[:space:]]*/,"");sub(/[[:space:]]+$/,"");print;exit}' "$r"
  fi
}

##############################################################
## This file can be included in a script with either
# [ -r /srv/scripts/bin/_get_config_value.sh ] && . /srv/scripts/bin/_get_config_value.sh

## or
# progdir=$(realpath "$0")
# progdir=${progdir%/*}
# [ -r $progdir/_get_config_value.sh ] && . $progdir/_get_config_value.sh

##############################################################
## Examples using the function
# config_file=config_test.ini

## Without sections
# test_key1=$(get_config_value "$config_file" test_key1)
# echo "test_key1 = '$test_key1'"

## With sections
# test_key1=$(get_config_value "$config_file" test_section test_key1)
# echo "test_key1 = '$test_key1'"

##############################################################
## Examples without using the function

## Without sections
# test_key1=$(awk -vk="test_key1" '$0~"^[[:space:]]*"k"[[:space:]]*[:=]"{sub(/^[^:=]+[:=][[:space:]]*/,"");sub(/[[:space:]]+$/,"");print;exit}' config_test.ini)

## With sections
# test_key1=$(awk -vs="test_section" -vk="test_key1" 'BEGIN{p=0}$0~/^[[:space:]]*\[/{p=0}$0~"^[[:space:]]*\\["s"\\]"{p=1}p==1&&$0~"^[[:space:]]*"k"[[:space:]]*[:=]"{sub(/^[^:=]+[:=][[:space:]]*/,"");sub(/[[:space:]]+$/,"");print;exit}' config_test.ini)

