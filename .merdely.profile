## Mike's Master .merdely.profile

# Add '[[ $- == *i* ]] && [ -r $HOME/.merdely.profile ] && . $HOME/.merdely.profile'
# to the bottom of $HOME/.profile or $HOME/.bashrc

[ -r /etc/os-release ] && . /etc/os-release
[ "$(uname -s)" = "OpenBSD" ] && export ID=OpenBSD

# Used in reload aliases below
USER_DOT_PROFILE=$HOME/.profile
[ -r $HOME/.bash_profile ] && USER_DOT_PROFILE=$HOME/.bash_profile
[ -z "$HOSTNAME" ] && export HOSTNAME="$(hostname -s)"

# Create $HOME/.cache directory
[ ! -d $HOME/.cache ] && mkdir -p $HOME/.cache > /dev/null 2>&1

# add_to_path smartly adds a directory to PATH
add_to_path() {
  if [ -z "$1" ] || [ -n "$2" -a "$1" != "-b" -a "$1" != "-e" -a "$1" != "-r" ]
  then
    echo "usage: add_to_path [-b|-e|-r] directory" > /dev/stderr
    echo "  -b: Add directory to beginning of PATH" > /dev/stderr
    echo "  -e: Add directory to end of PATH (default)" > /dev/stderr
    echo "  -r: Remove directory from PATH" > /dev/stderr
    echo "If either -b or -e are specified, any existing occurence of 'directory' is removed" > /dev/stderr
    return 1
  fi
  local DIR="$1"
  [ -n "$2" ] && DIR="$2"
  [ ! -d "$DIR" ] && return 1
  [ "$1" = "-b" -o "$1" = "-e" -o "$1" = "-r" ] && PATH=$(echo :$PATH: | sed -r "s!^(.*):$DIR:(.*)\$!\1:\2!;s!^:(.*):\$!\1!")
  [ "$1" = "-r" ] && return 0
  if [ "$1" = "-b" ]; then
    echo ":$PATH:" | grep -q ":$DIR:" || export PATH=$DIR:$PATH
  else
    echo ":$PATH:" | grep -q ":$DIR:" || export PATH=$PATH:$DIR
  fi
}

# SSH key stuff
# Command to fix the SSH Auth socket
[ -e $HOME/bin/fixsock ] && alias fixsock='. $HOME/bin/fixsock'
# Check if SSH connection or local
if [ -n "$SSH_CONNECTION" ]; then
  # Save what $HOME/.ssh/ssh-auth-sock originally linked to
  if [ $(uname -s) = Darwin ]; then
    export SSH_AUTH_SOCK_FILE_ORIG=$(python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' $HOME/.ssh/ssh-auth-sock)
  else
    export SSH_AUTH_SOCK_FILE_ORIG=$(readlink -f $HOME/.ssh/ssh-auth-sock)
  fi

  # Save what SSH_AUTH_SOCK originally was
  export SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK

  # Link SSH_AUTH_SOCK for this connection to $HOME/.ssh/ssh-auth-sock
  ln -sf $SSH_AUTH_SOCK $HOME/.ssh/ssh-auth-sock
else
  # Link to the ssh-agent socket file
  ln -sf $XDG_RUNTIME_DIR/ssh-agent.socket $HOME/.ssh/ssh-auth-sock
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh-auth-sock

# tmux-specific stuff
if which tmux > /dev/null 2>&1; then
  alias remain='fixsock; ssh localhost true; tmux -f $HOME/.tmux.conf.remain new-session -A -s main'
  [ -n "$TMUX" -o -n "$STY" ] && [ -e $HOME/.s_function ] && . $HOME/.s_function

  alias shass='w=$(tmux neww -P -nhass ssh homeassistant);sleep .5;tmux splitw -t$w ssh homeassistant;tmux send -t$w "cd /config;tail -F /config/home-assistant.log" Enter;tmux send -t${w%.*}.1 "cd /config" Enter;tmux selectl -t$w "baf4,186x56,0,0[186x11,0,0,1,186x44,0,12,18]";unset w'
  alias spis='w=$(s -P -l tiled -G sinope,carme,metis,carpo); tmux selectp -t ${w%%[[:space:]]*}.0; tmux renamew -t ${w%%[[:space:]]*} PIs;unset w'
  alias smercury='s -w 8 mercury;sleep .5;s -d -w 9 mercury'
  alias smedia='w=$(tmux neww -F "#{window_index}" -Pn media);tmux splitw -ht:$w;tmux splitw -vl4 -t:$w.{top-left};tmux splitw -vl4 -t:$w.{top-right};tmux splitw -vl4 -t:$w.{top-left};tmux splitw -vl4 -t:$w.{top-right};tmux splitw -vl4 -t:$w.{top-left};tmux splitw -vl4 -t:$w.{top-right};tmux selectl -t:$w.0 "5a0f,250x59,0,0{125x59,0,0[125x9,0,0,3,125x9,0,10,7,125x39,0,20,5],124x59,126,0[124x9,126,0,4,124x9,126,10,10,124x10,126,20,9,124x10,126,31,8,124x17,126,42,6]}";tmux selectp -t:$w.{bottom-right};tmux send -t:$w.0 "mediapane0" Enter;tmux send -t:$w.1 "mediapane1" Enter;tmux send -t:$w.2 "mediapane2" Enter;tmux send -t:$w.3 "mediapane3" Enter;tmux send -t:$w.4 "mediapane4" Enter;tmux send -t:$w.5 "mediapane5" Enter;tmux send -t:$w.6 "mediapane6" Enter;unset w'
fi

if [ $SHELL = /bin/bash ]; then
  # Try to do a shared command history
  if [ -z "$PROMPT_COMMAND" ]; then
    export PROMPT_COMMAND="history -a; history -c; history -r"
  else
    export PROMPT_COMMAND="history -a; history -c; history -r; $(echo $PROMPT_COMMAND | sed -r 's/history -a; history -c; history -r;? ?//g')"
  fi
  export PROMPT_COMMAND="$(echo $PROMPT_COMMAND | sed -r 's/; $//;s/;$//')"
fi

# Python stuff
which python2 > /dev/null 2>&1 && alias python=python2
which python3 > /dev/null 2>&1 && alias python=python3

# Functions for managing Python venvs
# Check if any venvs need updates
checkvenv() {
  for f in /srv/venv/*; do
    [ ! -d $f ] && continue
    s=$($f/bin/pip3 list --outdated --exclude idna)
    test -n "$s" && printf "$f:\n$s\n"
  done
}

mkvenv() {
  venv=/srv/venv
  [ -z "$1" ] && echo "usage: mkvenv DIRNAME (to be installed in $venv)"
  dir=$(basename $1)

  [ -e $venv/$1 ] && echo "Error: $venv/$1 exists" && return 1
  sudo="sudo -H"
  which sudo > /dev/null 2>&1
  [ $? != 0 -o $(uname -s) = OpenBSD ] && sudo=doas
  $sudo python3 -m venv $venv/$1
  $sudo $venv/$1/bin/pip install -U pip setuptools
}

updatevenv() {
  local wheels
  local use_wheels
  [ -f $HOME/.venvrc ] && . $HOME/.venvrc
  [ -n "$wheels" ] && use_wheels="--no-index --find-links=$wheels"
  sudo="sudo -H"
  which sudo > /dev/null 2>&1
  [ $? != 0 -o $(uname -s) = OpenBSD ] && sudo=doas
  for f in /srv/venv/*; do
    [ ! -d $f ] && continue
    unset s
    $sudo sh -c "s=\"$($f/bin/pip3 list --outdated --format=freeze|grep -Ev '^(idna)==')\" && test -n \"\$s\" && \
      { echo $f:; echo \"\$s\" | grep -v \"^\-e\" | cut -d= -f1 | xargs -n1 $f/bin/pip3 install -U $use_wheels; }"
    echo
  done
  unset f s
}

vinstall() {
  local venv
  local wheels
  local use_wheels
  local OPTIND opt
  local usage="usage: vinstall [-h] -v VENV PIPPACKAGE..."

  while getopts ":hv:" opt; do
    case $opt in
      v)
        venv=$OPTARG
        ;;
      h|\?)
        echo $usage
        return 1
        ;;
    esac
  done
  shift $((OPTIND -1))

  [ -z "$1" -o -z "$venv" ] && echo $usage && return 1
  [ ! -x /srv/venv/$venv/bin/pip ] && echo "Error: '$venv' is not a valid venv" && return 1

  [ -f $HOME/.venvrc ] && . $HOME/.venvrc
  [ -n "$wheels" ] && use_wheels="--no-index --find-links=$wheels"
  sudo -H /srv/venv/$venv/bin/pip install $use_wheels $*
}

# Media stuff
findmovie() {
  local showtorrents=no
  [ "$1" = "" ] && echo "usage: findmovie [-t] moviename" > /dev/stderr && return 1
  [ "$1" = "-t" ] && showtorrents=yes && shift
  local searchstr=$(echo "$*" | sed 's/[ _.]/\[ _.\]/g')
  { find /share/media/Movies -iname "*${searchstr}*" -size +10000; \
  [ "$showtorrents" = "yes" ] && find /torrent/Torrents -iname "*${searchstr}*.torrent"; } | sort
}
alias fm=findmovie

alias checkencode='stat -c "%s %n" /torrent/2convert/.work*/* | awk "/\/torrent\/2convert\/.work/ { printf \"%0d M %s\n\",\$1/1000/1000,gensub(/\/torrent\/2convert\/\.work_([^/]+)\//, \"\\\\1: \", \"g\", \$2) }"'
alias checkconvert=checkencode
alias watchencode='while true; do s=$(stty size);curl -sN "http://thebe:8080/conv?text&n=${s% *}&w=${s#* }";sleep 2;done;unset s'
alias watchconvert=watchencode
alias watchsave='while true; do s=$(stty size);curl -sN "http://thebe:8080/xfer?text&n=${s% *}&w=${s#* }";sleep 2;done;unset s'


alias lspending='printf "2convert: "; ls /torrent/2convert/*.* 2> /dev/null | wc -l; printf "done: "; ls /torrent/Done/*.mp4 2> /dev/null | wc -l'
export trserver=thebe
alias tdown='cat /torrent/log/watchtr|awk "\$6 !~ /(Stop|Idle|Seed|Fini)/ { print }"'
alias tls='ls /torrent/Torrents/*.torrent > /dev/null 2>&1 && ls /torrent/Torrents/*.torrent'
alias trl='curl -s -N "http://thebe:8080/?text"'
alias trr='ssh -qt thebe docker exec xmission transmission-remote'
which transmission-remote > /dev/null 2>&1 || alias transmission-remote='ssh -qt thebe docker exec xmission transmission-remote'
alias tstat="ssh -qt $trserver /home/research/bin/tstat"

## Tmux media window aliases
alias mediapane0='tail -n 1000 -F /torrent/log/cleanup-finished-torrents.log'
alias mediapane1='tail -n 1000 -F /torrent/log/save-downloaded-torrent.log'
alias mediapane2='m=wtrd;while true;do s=$(stty size);echo -n "Time: $(date "+%T") | ";curl -s -N "http://thebe:8080/?text&$m&notime&n=${s% *}&w=${s#* }";sleep 2;done;unset s m'
alias mediapane3='tail -n 1000 -F /torrent/log/save_videos.log'
alias mediapane4='tail -n 1000 -F /torrent/log/convert_videos.log'
alias mediapane5='while true; do s=$(stty size);curl -sN "http://thebe:8080/conv?text&n=${s% *}&w=${s#* }";sleep 2;done;unset s'
alias mediapane6='while true; do s=$(stty size);curl -sN "http://thebe:8080/xfer?text&n=${s% *}&w=${s#* }";sleep 2;done;unset s'

alias wcf='tail -n 1000 -F /torrent/log/cleanup-finished-torrents.log'
alias wsv='tail -n 1000 -F /torrent/log/save_videos.log'
alias wst='tail -n 1000 -F /torrent/log/save-downloaded-torrent.log'
alias wcv='tail -n 1000 -F /torrent/log/convert_videos.log'
alias wtr='m=wtr;while true;do s=$(stty size);echo -n "Time: $(date "+%T") | ";curl -s -N "http://thebe:8080/?text&$m&notime&n=${s% *}&w=${s#* }";sleep 2;done; unset s m'
alias wtrd='m=wtrd;while true;do s=$(stty size);echo -n "Time: $(date "+%T") | ";curl -s -N "http://thebe:8080/?text&$m&notime&n=${s% *}&w=${s#* }";sleep 2;done; unset s m'

# Command aliases
which view > /dev/null 2>&1 || alias view='vi -R'
if which vim > /dev/null 2>&1; then
  alias vi=vim
  alias nvi=/usr/bin/vi
  which svn > /dev/null 2>&1 && export SVN_EDITOR=vim
else
  which svn > /dev/null 2>&1 && export SVN_EDITOR=vi
fi
which git > /dev/null 2>&1 && alias gitpush='git push -u origin master'

# Ansible aliases
which ansible-playbook > /dev/null 2>&1 && alias ap=ansible-playbook
which ansible-playbook > /dev/null 2>&1 && alias apv='ansible-playbook --ask-vault-pass'
if [ -d $HOME/src/ansible/system-setup ]; then
  which ansible-playbook > /dev/null 2>&1 && alias apconfigs='ansible-playbook $HOME/src/ansible/system-setup/server-setup.yml --ask-vault-pass -e target=servers -t configs'
  which ansible-playbook > /dev/null 2>&1 && alias apsshconfigs='ansible-playbook $HOME/src/ansible/system-setup/server-setup.yml --ask-vault-pass -e target=servers -t sshconfigs'
  which ansible-playbook > /dev/null 2>&1 && alias apupdates='ansible-playbook $HOME/src/ansible/system-setup/server-setup.yml --ask-vault-pass -e target=servers -t updates'
fi

# General aliases
alias ls='ls -F'
[ $(uname -s) = Linux ] && alias ls='ls -N --color=auto'
alias cdp='cd $(pwd -P)'
[ -e /dev/pf ] && alias pflog='doas tcpdump -n -e -ttt -i pflog0'
[ -e $HOME/bin/nohist ] && alias nohist='. $HOME/bin/nohist'
alias pcp='rsync --progress -a'
# Common typos
alias Grep=grep
alias Less=less
alias More=more
# RPI commands
which vcgencmd > /dev/null 2>&1 && alias gettemp='echo $(echo "$(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}")*9/5+32" | bc) F'
which vcgencmd > /dev/null 2>&1 && alias gettempc='echo $(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}") C'
# Print neofetch when clearing screen
[ -r $HOME/.neofetch ] && alias clear='/usr/bin/clear;cat $HOME/.neofetch'
[ "$ID" = debian -o "$ID_LIKE" = debian -a -r $HOME/.neofetch ] && alias clear='/usr/bin/clear;uname -snrvm;cat /etc/motd;lastlog -u $LOGNAME|awk -vl=$LOGNAME "\$1==l{printf \"Last login: %s %s %2s %s %s from %s\n\",\$4,\$5,\$6,\$7,\$9,\$3}"; cat $HOME/.neofetch'
[ -r /etc/armbian-release -a -r $HOME/.neofetch ] && alias clear='/usr/bin/clear;uname -snrvm;cat /run/motd.dynamic;lastlog -u $LOGNAME|awk -vl=$LOGNAME "\$1==l{printf \"Last login: %s %s %2s %s %s from %s\n\",\$4,\$5,\$6,\$7,\$9,\$3}"; cat $HOME/.neofetch'
# sudo/doas aliases
alias sudo='sudo '
which sudo > /dev/null 2>&1
ret_sudo=$?
which doas > /dev/null 2>&1
ret_doas=$?
[ $ret_sudo != 0 -a $ret_doas = 0 ] && alias sudo=doas
[ $ret_sudo = 0 -a $ret_doas != 0 ] && alias doas=sudo
alias rebashrc='. $USER_DOT_PROFILE reload'
alias reprofile='. $USER_DOT_PROFILE reload'
alias check_reboot='sudo /srv/scripts/sbin/daily_report_linux reboot'
alias check_restart='sudo /srv/scripts/sbin/daily_report_linux restart'

# Aliases to keep edits to $HOME/.merdely.profile & $HOME/.vimrc in sync
if [ -e $HOME/src/ansible/system-setup/roles/system/files/dot_merdely.profile ]; then
  alias ep='vi $HOME/src/ansible/system-setup/roles/system/files/dot_merdely.profile; cp $HOME/src/ansible/system-setup/roles/system/files/dot_merdely.profile $HOME/.merdely.profile'
  alias sp='cp $HOME/.merdely.profile $HOME/src/ansible/system-setup/roles/system/files/dot_merdely.profile'
fi
if [ -e $HOME/src/ansible/system-setup/roles/system/files/dot_vimrc ]; then
  alias ev='vi $HOME/src/ansible/system-setup/roles/system/files/dot_vimrc; cp $HOME/src/ansible/system-setup/roles/system/files/dot_vimrc $HOME/.vimrc'
  alias sv='cp $HOME/.vimrc $HOME/src/ansible/system-setup/roles/system/files/dot_vimrc'
fi

# Command aliases is specific docker containers are running
if [ -d /srv/docker/nagios ]
then
  alias nagioscheck='docker exec nagios nagios4 -v /etc/nagios4/nagios.cfg'
  alias nagiosreload='docker exec nagios pkill -HUP nagios4'
fi
if [ -d /srv/docker/nginx ]
then
  alias nginxcheck='docker exec nginx nginx -t'
  alias nginxreload='docker exec nginx nginx -s reload'
fi

# Run findmultiples on Jupiter for access to the Plex SQLite DB
alias findmultiples='ssh jupiter /srv/scripts/bin/findmultiples'

# Some host-specific settings
case "$HOSTNAME" in
  jupiter)
    unalias findmultiples
    ;;
  mercury)
    case "$ID" in
      arch)
        alias bootwindows='sudo /srv/scripts/sbin/boot-to-windows'
        alias bootlinux='sudo /srv/scripts/sbin/boot-to-arch'
        alias bootarch='sudo /srv/scripts/sbin/boot-to-arch'
        which nvidia-settings > /dev/null 2>&1 && alias nvidiacheck='nvidia-settings -q "[gpu:0]/GpuPowerMizerMode"'
        which nvidia-settings > /dev/null 2>&1 && alias nvidiaset='nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1"'
        ;;
      ubuntu)
        unalias vi
        [ -x /usr/bin/vim.tiny ] && export SVN_EDITOR="/usr/bin/vim.tiny -Cu /dev/null"
        alias listboot='sudo sha256sum /boot/efi/EFI/ubuntu/grubenv{,.linux,.windows}|sort'
        ;;
      fedora|centos)
        alias enablefusion='sudo dnf config-manager --set-enabled rpmfusion-free rpmfusion-free-updates'
        alias disablefusion='sudo dnf config-manager --set-disabled rpmfusion-free rpmfusion-free-updates'
        alias fixbridge='sudo /usr/sbin/iptables -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT'
        alias vi=vim
        ;;
    esac
    sync_dotfiles() {
      DST=$HOME/git/dotfiles
      mkdir -vp $DST
      cp -v $HOME/{.bash_logout,.bashrc,.logout_ssh,.merdely.profile,.vimrc,.Xresources,.xbindkeysrc,.xprofile} $DST
      mkdir -vp $DST/bin $DST/.config/{dunst,fittstool,kitty,qtile,rofi,xset}
      cp -v $HOME/bin/{adjust_brightness,qtile_*.sh,term} $DST/bin
      cp -v $HOME/.config/{mimeapps.list,picom.conf,rofimoji.rc} $DST/.config/
      cp -v $HOME/.config/dunst/dunstrc $DST/.config/dunst/
      cp -v $HOME/.config/fittstool/fittstoolrc $DST/.config/fittstool/
      cp -v $HOME/.config/kitty/kitty.conf $DST/.config/kitty/
      cp -v $HOME/.config/qtile/config.py $DST/.config/qtile/
      cp -v $HOME/.config/rofi/config.rasi $DST/.config/rofi/
      cp -v $HOME/.config/xset/* $DST/.config/xset/
    }
    alias change_password='tmux neww -d -n chpass ; for f in mars ares earth jupiter venus thebe sinope carme metis atlas; do tmux splitw -d -t:$ "ssh $f"; tmux select-layout -t:$ tiled; done; tmux set -w -t:$ synchronize-panes; tmux set -w -t:$ pane-active-border-style fg=red; tmux select-layout -t:$ main-vertical; tmux select-window -t:$'
    ;;
  earth)
    alias influx='docker exec -it influxdb influx -host influxdb.erdely.in -ssl -username admin -password ""'
    alias restartcams='/usr/local/bin/docker-compose -f /srv/docker/docker-compose.yaml restart $(/usr/bin/docker ps --format {{.Names}} | grep restreamer-)'
    export RESTIC_REPOSITORY=/ext/Fantom4TB/restic
    ;;
  ceres)
    alias pubip='echo $(/usr/bin/ftp -MVo - http://169.254.169.254/latest/meta-data/public-ipv4)'
    ;;
  pluto)
    alias pubip='ifconfig egress | awk "\$1==\"inet\"{print \$2}"'
    ;;
esac

# OS Specific Commands
case "$ID" in
  arch)
    alias ru='sudo reflector -c us -p https -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
    ;;
  OpenBSD)
    # Print status of command without interrupting it (e.g. ping)
    stty status '^T'

    # Allow ps on OpenBSD to accept -ef
    ps() {
      local W
      if [ $(echo "$1" | cut -b 1-3) = "-ef" ]; then
        echo "$*" | grep -q "w" 2> /dev/null && W=-w
        echo "$*" | grep -q "ww" 2> /dev/null && W=-ww
        /bin/ps -A -o user,pid,ppid,pcpu,start,tty,time,args $W
      else
        /bin/ps $*
      fi
    }
    ;;
esac

# Set some variables
which virsh > /dev/null 2>&1 && export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
[ -r /srv/docker/docker-compose.yaml ] && export COMPOSE_FILE=/srv/docker/docker-compose.yaml
which docker > /dev/null 2>&1 && export COMPOSE_DOCKER_CLI_BUILD=0
export LESS=RX
export HISTFILE=$HOME/.cache/bash_history
export HISTFILESIZE=10000
export HISTSIZE=10000
export EDITOR=vi
set -o vi

# Some default settings
umask 0022
export PS1='[\u@\h \W]\$ '
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
[ -x /usr/lib/nagios/plugins/check_disk ] && add_to_path /usr/lib/nagios/plugins
add_to_path -b $HOME/svn/scripts/bin
add_to_path -b $HOME/.local/bin
add_to_path -b $HOME/bin
add_to_path -e /usr/sbin

[ ! $PROFILEDONE ] && [ -r $HOME/.neofetch ] && cat $HOME/.neofetch
export PROFILEDONE=yes
[ -e $HOME/.profile.local ] && . $HOME/.profile.local
