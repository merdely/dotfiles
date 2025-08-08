## Mike's Master .merdely.profile

# Add '[[ $- == *i* ]] && [ -r $HOME/.merdely.profile ] && . $HOME/.merdely.profile'
# to the bottom of $HOME/.profile or $HOME/.bashrc

[ -r /etc/os-release ] && . /etc/os-release
[ "$(uname -s)" = "OpenBSD" ] && export ID=OpenBSD

# Used in reload aliases below
USER_DOT_PROFILE=$HOME/.profile
[ -r $HOME/.bash_profile ] && USER_DOT_PROFILE=$HOME/.bash_profile
[ -z "$HOSTNAME" ] && export HOSTNAME="$(hostname -s)"
HOSTNAME=${HOSTNAME%%.*}

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
    [[ ":$PATH:" == *":$DIR:"* ]] || export PATH=$DIR:$PATH
  else
    [[ ":$PATH:" == *":$DIR:"* ]] || export PATH=$PATH:$DIR
  fi
}

# function to resolve links to their real path
resolve_link() {
  [ ! -e "$1" -o -z "$1" ] && return 1
  if [ $(uname -s) = Darwin ]; then
    python -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$1"
  else
    readlink -f "$1"
  fi
}

# Set some variables
which virsh > /dev/null 2>&1 && export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
[ -r /srv/docker/docker-compose.yaml ] && export COMPOSE_FILE=/srv/docker/docker-compose.yaml
[ -r /srv/docker/compose.yaml ] && export COMPOSE_FILE=/srv/docker/compose.yaml
[ -r /srv/docker/$HOSTNAME/compose.yaml ] && export COMPOSE_FILE=/srv/docker/$HOSTNAME/compose.yaml
[ -r /srv/containers/$HOSTNAME/compose.yaml ] && export COMPOSE_FILE=/srv/containers/$HOSTNAME/compose.yaml
if which docker > /dev/null 2>&1; then
  export COMPOSE_DOCKER_CLI_BUILD=0
  docker() {
    case "$1" in
      commit)
        shift
        /usr/bin/docker commit $*
        ;;
      c|co|com*|cmo*|ocmp*|ocmo*)
        shift
        /usr/bin/docker compose $*
        ;;
      *)
        /usr/bin/docker $*
        ;;
    esac
  }
fi

# General settings
umask 0022
export LESS=REX
export NIFS=$(printf "\n\b")
export OIFS=$IFS
export PS1='[\u@\h \W]\$ '
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
[ -x /usr/lib/nagios/plugins/check_disk ] && add_to_path /usr/lib/nagios/plugins
add_to_path -b $HOME/.local/bin
add_to_path -b $HOME/bin
add_to_path -e /usr/sbin
[ -d /srv/scripts/bin ]  && add_to_path -e /srv/scripts/bin
[ -d /srv/scripts/sbin ] && add_to_path -e /srv/scripts/sbin
[ -z "$EUID" ] && export EUID=$(id -u)

# General aliases
alias ls='ls -F'
[ $(uname -s) = Linux ] && alias ls='ls -N --color=auto'
alias cdp='cd $(pwd -P)'
[ -e /dev/pf ] && alias pflog='doas tcpdump -n -e -ttt -i pflog0'
[ -e /srv/scripts/bin/nohist ] && alias nohist='. /srv/scripts/bin/nohist'
alias dos_rsync='rsync -rtcvP'
alias utcdate='TZ=UTC date "+%a %b %d %H:%M:%S %Z %Y"'
! which mail > /dev/null 2>&1 && which s-nail > /dev/null 2>&1 && alias mail=s-nail
alias printenv='printenv|sort'
alias rebashrc='. $USER_DOT_PROFILE reload'
alias reprofile='. $USER_DOT_PROFILE reload'
alias check_reboot='sudo /srv/scripts/sbin/daily_report_linux reboot'
alias check_restart='sudo /srv/scripts/sbin/daily_report_linux restart'
alias sqlite=sqlite3
getent passwd splunk > /dev/null && alias susplunk='sudo su - splunk'
alias suacme='sudo su - -s /bin/bash -l acme'
which mpv > /dev/null 2>&1 && alias mpv='DBUS_FATAL_WARNINGS=0 mpv'

# Common typos
alias Grep=grep
alias Less=less
alias More=more

# Editor aliases
set -o vi  # vi mode for command line editing
which view > /dev/null 2>&1 || alias view='vi -R'
if which nvim > /dev/null 2>&1; then
  alias vi=nvim
  alias nvi=/usr/bin/vi
  export EDITOR=nvim
  export SUDO_EDITOR=nvim
elif which vim > /dev/null 2>&1; then
  alias vi=vim
  alias nvi=/usr/bin/vi
  export EDITOR=vim
  export SUDO_EDITOR=vim
else
  export EDITOR=vi
  export SUDO_EDITOR=vi
fi

# Editor aliases
which hyprctl > /dev/null 2>&1 && alias vih='vi -O ~/.config/hypr/hyprland.conf'
which hyprctl > /dev/null 2>&1 && alias vihl='vi ~/.config/local/hyprland.conf'
which hyprctl > /dev/null 2>&1 && alias vihb='vi -O ~/.config/hypr/hyprland.conf ~/.config/local/hyprland.conf'
which i3-msg  > /dev/null 2>&1 && alias vi3='vi ~/.config/i3/config'
which swaymsg > /dev/null 2>&1 && alias vis='vi ~/.config/sway/config'
which niri    > /dev/null 2>&1 && alias vin='vi ~/.config/niri/config.kdl'
which nvim    > /dev/null 2>&1 && alias viv='vi ~/.config/nvim/init.lua'

# DNS Command aliases
if which dog > /dev/null 2>&1; then
  which dig > /dev/null 2>&1 || alias dig=dog
  which host > /dev/null 2>&1 || alias host=dog
fi

# Python stuff
which python2 > /dev/null 2>&1 && alias python=python2
which python3 > /dev/null 2>&1 && alias python=python3

# Ansible aliases
if which ansible-playbook > /dev/null 2>&1; then
  alias ap=ansible-playbook
  alias apv='ansible-playbook --ask-vault-pass'
  alias apkv='ANSIBLE_SSH_ARGS="-o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook --ask-vault-pass'
  alias apk='ANSIBLE_SSH_ARGS="-o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook'
  export ANSIBLE_NOCOWS=1
fi

# Some docker aliases
if which docker > /dev/null 2>&1; then
  alias dc='docker compose'
  alias dce='docker compose exec'
  alias dcl='docker compose logs -f'
fi

# Command aliases is specific docker containers are running
if which docker > /dev/null 2>&1 && docker ps --format "{{.Names}}" | grep -q "^nagios$"; then
  alias nagioscheck='docker compose exec nagios nagioscheck'
  alias nagiosreload='docker compose exec nagios nagiosreload'
fi

if which docker > /dev/null 2>&1 && docker ps --format "{{.Names}}" | grep -q "^nginx$"; then
  alias nginxcheck='docker compose exec nginx nginx -t'
  alias nginxreload='docker compose exec nginx nginx -s reload'
fi

if ! which ollama > /dev/null 2>&1 && which docker > /dev/null 2>&1 && \
      docker ps --format "{{.Names}}" | grep -q "^ollama$"; then
  alias ollama='docker compose -f $COMPOSE_FILE exec -it ollama ollama'
fi

if ! which psql > /dev/null 2>&1 && which docker > /dev/null 2>&1 && \
      docker ps --format "{{.Names}}" | grep -q "^postgres$"; then
  alias psql='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres env HISTSIZE=10000 HISTFILE=~/.psql_history psql'
  alias pbash='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres bash'
  alias pg_dump='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres pg_dump'
  alias pg_dumpall='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres pg_dumpall'
  alias pg_restore='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres pg_restore'
  alias createuser='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres createuser'
  alias dropuser='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres dropuser'
  alias createdb='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres createdb'
  alias dropdb='docker compose -f $COMPOSE_FILE exec -it -u postgres postgres dropdb'
fi

if which docker > /dev/null 2>&1 && docker ps --format "{{.Names}}" | grep -Eq "^(mysql|mariadb)$"; then
  which mysql > /dev/null 2>&1 || alias mysql="docker compose exec -it -u mysql mysql mariadb"
  which mariadb > /dev/null 2>&1 || alias mariadb="docker compose exec -it -u mysql mysql mariadb"
  which mysqldump > /dev/null 2>&1 || alias mysqldump="docker compose exec -it -u mysql mysql mariadb-dump"
  which mariadb-dump > /dev/null 2>&1 || alias mariadb-dump="docker compose exec -it -u mysql mysql mariadb-dump"
fi

# RPI commands
which vcgencmd > /dev/null 2>&1 && alias gettemp='echo $(echo "$(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}")*9/5+32" | bc) F'
which vcgencmd > /dev/null 2>&1 && alias gettempc='echo $(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}") C'

# sudo/doas aliases
alias sudo='sudo '
which sudo > /dev/null 2>&1
ret_sudo=$?
which doas > /dev/null 2>&1
ret_doas=$?
[ $ret_sudo != 0 -a $ret_doas = 0 ] && alias sudo=doas
[ $ret_sudo = 0 -a $ret_doas != 0 ] && alias doas=sudo

## Check to see if $HOME is writeable
#HOME_WRITEABLE=0
#touch $HOME/.write_test 2> /dev/null && HOME_WRITEABLE=1 && rm -f $HOME/.write_test

## Create $HOME/.cache directory
#[ $HOME_WRITEABLE = 1 ] && [ ! -d $HOME/.cache ] && mkdir -p $HOME/.cache > /dev/null 2>&1

#XDG PATHS (https://wiki.archlinux.org/title/XDG_Base_Directory)
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:=$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:=$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:=/run/user/$EUID}
export XDG_DATA_DIRS=$XDG_DATA_HOME:${XDG_DATA_DIRS:=/usr/local/share:/usr/share}

# Make sure specific XDG directories are writeable
[ ! -w $XDG_RUNTIME_DIR ] && export XDG_RUNTIME_DIR=/tmp/.$EUID && mkdir -p -m 700 $XDG_RUNTIME_DIR
[ ! -w $XDG_CACHE_HOME ] && export XDG_CACHE_HOME=$XDG_RUNTIME_DIR/.cache && mkdir -p -m 700 $XDG_CACHE_HOME
[ ! -w $XDG_STATE_HOME ] && export XDG_STATE_HOME=$XDG_RUNTIME_DIR/.state && mkdir -p -m 700 $XDG_STATE_HOME

## Handle when Home is not writeable
#if [ $HOME_WRITEABLE = 0 ]; then
#  mkdir -p -m 700 $XDG_RUNTIME_DIR/.cache/{vim,vim_backup}
#  mkdir -p -m 700 $XDG_RUNTIME_DIR/.cargo
#  mkdir -p -m 700 $XDG_RUNTIME_DIR/.ansible
#fi

# Handle with / is read-only
if [ -r /boot/cmdline.txt ] && grep -qE "\<ro\>" /boot/cmdline.txt; then
  alias check_root='sudo lsof / | awk "NR==1 || \$4~/[0-9]+[uw]/"'
fi

# Set other PATH files
export CARGO_HOME=$XDG_DATA_HOME/cargo
export DEAD=$XDG_CACHE_HOME/dead.letter
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export HISTFILE=$XDG_CACHE_HOME/shell_history
export LESSHISTFILE=$XDG_CACHE_HOME/.lesshst

# Create SSH ctl directory
[ ! -d $XDG_RUNTIME_DIR/ssh-ctl ] && mkdir -m 700 -p $XDG_RUNTIME_DIR/ssh-ctl
[ ! -L $HOME/.ssh/ctl ] && ln -s $XDG_RUNTIME_DIR/ssh-ctl $HOME/.ssh/ctl

# SSH key stuff
if [ -n "$SSH_CONNECTION" ] && [ ! -S $XDG_RUNTIME_DIR/ssh-auth-sock ] && [ -S "$SSH_AUTH_SOCK" ]; then
  ln -sf $SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-auth-sock
fi

# SSH without saving known_hosts
alias rsynck='rsync -e "ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"'
alias sshk='ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scpk='scp -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# tmux-specific stuff
if which tmux > /dev/null 2>&1; then
  alias remain='tmux -f $HOME/.config/tmux/tmux.conf.remain new-session -A -s main'

  alias shass='w=$(tmux neww -Pnhass "ssh ha");w=${w#*:};o=$(tmux run -d .5 "true");tmux splitw -vl 77% -t "$w" "ssh ha";tmux send -t "${w%.*}.0" "tail -F /config/home-assistant.log" Enter;tmux selectp -t ":${w%.*}.{bottom-right}";unset w o'
  if [ "${HOSTNAME%%.*}" = mercury ] && [ "${SSH_CLIENT%% *}" = 192.168.25.38 -o "${SSH_CLIENT%% *}" = 192.168.25.38 ]; then
    alias tmux='ssh carme tmux'
    alias shass='w=$(ssh carme "tmux neww -Pnhass \"ssh ha\"");w=${w#*:};o=$(ssh carme "tmux run -d .5 \"true\"");ssh carme "tmux splitw -vl 77% -t \"$w\" \"ssh ha\"";ssh carme "tmux send -t \"${w%.*}.0\" \"tail -F /config/home-assistant.log\" Enter";ssh carme "tmux selectp -t \":${w%.*}.{bottom-right}\"";unset w o'
  fi
fi

# Git stuff
if echo $SHELL | grep -Eq "^.*/bash$" || echo $SHELL | grep -Eq "^.*/ksh$"; then
  if ! typeset -f __git_ps1 > /dev/null 2>&1 && [ -e /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
  fi
  if ! typeset -f __git_ps1 > /dev/null 2>&1 && [ -e $HOME/bin/git-prompt.sh ]; then
    . $HOME/bin/git-prompt.sh
  fi
  if typeset -f __git_ps1 > /dev/null 2>&1; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWCOLORHINTS=true
    export PS1='[\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\]]$(__git_ps1 " (%s)")\$ '
    if echo $SHELL | grep -Eq "^.*/bash$" && ! echo ";$PROMPT_COMMAND;" | grep -qE '; ?__git_ps1 "\[\\\[\\e\[1;36m\\\]\\u\\\[\\e\[0m\\\]@\\\[\\e\[1;32m\\\]\\h\\\[\\e\[0m\\\] \\\[\\e\[1;34m\\\]\\W\\\[\\e\[0m\\\]\]" "\\\\\\\$ " ?;'; then
      export PROMPT_COMMAND="$(echo "$PROMPT_COMMAND; "'__git_ps1 "[\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\]]" "\\\$ "' | sed -r 's/^ ?; ?//;s/ ?; ?$//')"
    fi
  fi
fi
gitcmd=$(which git 2> /dev/null)
if [ -n "$gitcmd" ]; then
  if ! pgrep -x gpg-agent > /dev/null 2>&1; then
    export GPG_TTY=$(tty)
  fi
fi

# History stuff (needs to come after Git stuff)
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTCONTROL=ignoreboth:erasedups
[ -n "$BASH_VERSION" ] && shopt -s histappend
if [[ "$HOME_WRITEABLE" ]] && [[ $SHELL =~ ^(/usr)?/bin/bash$ ]]; then
  # Try to do a shared command history
  if ! echo ";$PROMPT_COMMAND;" | grep -qE "; ?history -a; history -c; history -r ?;"; then
    export PROMPT_COMMAND="$(echo "history -a; history -c; history -r; $PROMPT_COMMAND" | sed -r 's/^ ?; ?//;s/ ?; ?$//')"
  fi
fi

# Random password generator
passgen() {
  LENGTH=$1
  tr -cd '[:alnum:]' < /dev/urandom | fold -w ${LENGTH:-64} | head -n 1 | tr -d '\n' ; echo
}

# Some host-specific settings
case "$HOSTNAME" in
  mercury)
    case "$ID" in
      arch)
        alias remain='echo SSH to carme'
        alias bootwindows='sudo /srv/scripts/sbin/boot-to-windows'
        alias bootlinux='sudo /srv/scripts/sbin/boot-to-arch'
        alias bootarch='sudo /srv/scripts/sbin/boot-to-arch'
        alias pushprofile='for f in pluto jupiter earth dione carme tarvos sinope; do echo $f; scp $HOME/.merdely.profile $f:; done; for f in metis; do echo $f; ssh root@$f /usr/local/bin/rw; scp $HOME/.merdely.profile $f:; ssh root@$f /usr/local/bin/ro; done; for f in carme tarvos sinope; do echo $f: sync_home; ssh -o ClearAllForwardings=yes root@$f /home/mike/bin/sync_home > /dev/null; done'
        alias pushknownhosts='for f in pluto jupiter mercury earth dione; do echo $f; scp $HOME/src/ansible/system-setup/roles/sshclient/files/ssh_known_hosts root@$f:/etc/ssh/ssh_known_hosts; done; for f in carme metis tarvos; do echo $f; ssh -o ClearAllForwardings=yes root@$f /usr/local/bin/rw; scp $HOME/src/ansible/system-setup/roles/sshclient/files/ssh_known_hosts root@$f:/etc/ssh/ssh_known_hosts; ssh -o ClearAllForwardings=yes root@$f /usr/local/bin/ro; done'
        alias pushvimrc='for f in jupiter earth pluto carme; do echo $f; scp $HOME/.vimrc $f:; done; for f in carme; do echo $f: sync_home; ssh -o ClearAllForwardings=yes root@$f /home/mike/bin/sync_home > /dev/null; done'
        ;;
    esac
    alias change_password='tmux neww -d -n chpass ; for f in earth jupiter dione venus tarvos sinope carme metis; do tmux splitw -d -t:$ "ssh $f"; tmux select-layout -t:$ tiled; done; tmux set -w -t:$ synchronize-panes; tmux set -w -t:$ pane-active-border-style fg=red; tmux select-layout -t:$ main-vertical; tmux select-window -t:$'
    ;;
  pluto)
    alias pubip='ifconfig egress | awk "\$1==\"inet\"{print \$2}"'
    ;;
esac

# OS Specific Commands
case "$ID" in
  arch|archarm)
    alias ls_aur='pacman -Qm'
    alias ls_orphans='pacman -Qdtq'
    alias rm_orphans='pacman -Qdtq > /dev/null 2>&1 && sudo pacman -Rcns $(pacman -Qdtq)'
    alias ru='sudo reflector -c US -p https -f 5 --sort rate --save /etc/pacman.d/mirrorlist'
    if which paru &> /dev/null; then
      alias updates='echo Using paru; paru'
    else
      alias updates='echo Using pacman; sudo pacman -Syu --noconfirm'
      alias paru='echo paru not installed; sudo pacman -Syu'
    fi
    ;;
  debian|ubuntu)
    alias updates='echo Using apt dist-upgrade; sudo apt update && sudo apt dist-upgrade -y'
    ;;
  OpenBSD)
    # Print status of command without interrupting it (e.g. ping)
    stty status '^T'
    export LESS=FRSXc

    # Allow ps on OpenBSD to accept -ef
    ps() {
      local W
      if [ $(echo "$1" | cut -b 1-3) = "-ef" ]; then
        [[ "$@" == *"w"* ]] && W=-w
        [[ "$@" == *"ww" ]] && W=-ww
        /bin/ps -A -o user,pid,ppid,pcpu,start,tty,time,args $W
      else
        /bin/ps "$@"
      fi
    }
    ;;
esac

export PROFILEDONE=yes
[ -e $HOME/.profile.local ] && . $HOME/.profile.local

# Wayland stuff
if [ "$XDG_SESSION_TYPE" = wayland ]; then
  export SSH_ASKPASS=$HOME/bin/yad-askpass
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
fi

# Wayland stuff over SSH
if [[ $SSH_CONNECTION ]]; then
  WAYLAND_DISPLAY_FILE=$(find $XDG_RUNTIME_DIR -maxdepth 1 -regex ".*/wayland-[0-9]+")
  if [[ $WAYLAND_DISPLAY_FILE ]]; then
    export XDG_SESSION_TYPE=wayland
    export WAYLAND_DISPLAY=$(basename "$WAYLAND_DISPLAY_FILE")

    if which niri > /dev/null 2>&1; then
      NIRI_SOCKET=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "niri.wayland-*.sock")
      [[ $NIRI_SOCKET ]] && export NIRI_SOCKET
    fi

    if which hyprctl > /dev/null 2>&1; then
      HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl -j instances 2>/dev/null | jq -r '.[-1].instance' 2> /dev/null)
      [[ $HYPRLAND_INSTANCE_SIGNATURE ]] && export HYPRLAND_INSTANCE_SIGNATURE
    fi

    if which swaymsg > /dev/null 2>&1; then
      SWAYSOCK=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "sway-ipc.*.*.sock")
      [[ $SWAYSOCK ]] && export SWAYSOCK
    fi
  fi
fi

