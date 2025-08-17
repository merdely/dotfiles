## Mike's Master .merdely.profile

# Add '[[ $- == *i* ]] && [ -r $HOME/.merdely.profile ] && source $HOME/.merdely.profile'
# to the bottom of $HOME/.profile or $HOME/.bashrc

[ -r /etc/os-release ] && source /etc/os-release
[ "$(uname -s)" = "OpenBSD" ] && export ID=OpenBSD

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

# Used in reload aliases below
[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname -s)"
export HOSTNAME=${HOSTNAME%%.*}

# COLORS
CLEAR="\[\e[0m\]"

BLACK="\[\033[0;30m\]"
BLACK_BOLD="\[\033[1;30m\]"
BLACK_UNDERLINE="\[\033[4;30m\]"
BLACK_DIM="\[\033[2;30m\]"
BLACK_REVERSE="\[\033[7;30m\]"

BLUE="\[\033[0;34m\]"
BLUE_BOLD="\[\033[1;34m\]"
BLUE_DIM="\[\033[2;34m\]"
BLUE_UNDERLINE="\[\033[4;34m\]"
BLUE_REVERSE="\[\033[7;34m\]"

CYAN="\[\033[0;36m\]"
CYAN_BOLD="\[\033[1;36m\]"
CYAN_DIM="\[\033[2;36m\]"
CYAN_UNDERLINE="\[\033[4;36m\]"
CYAN_REVERSE="\[\033[7;36m\]"

GREEN="\[\033[0;32m\]"
GREEN_BOLD="\[\033[1;32m\]"
GREEN_DIM="\[\033[2;32m\]"
GREEN_UNDERLINE="\[\033[4;32m\]"
GREEN_REVERSE="\[\033[7;32m\]"

PURPLE="\[\033[0;35m\]"
PURPLE_BOLD="\[\033[1;35m\]"
PURPLE_DIM="\[\033[2;35m\]"
PURPLE_UNDERLINE="\[\033[4;35m\]"
PURPLE_REVERSE="\[\033[7;35m\]"

RED="\[\033[0;31m\]"
RED_BOLD="\[\033[1;31m\]"
RED_DIM="\[\033[2;31m\]"
RED_UNDERLINE="\[\033[4;31m\]"
RED_REVERSE="\[\033[7;31m\]"

WHITE="\[\033[0;37m\]"
WHITE_BOLD="\[\033[1;37m\]"
WHITE_DIM="\[\033[2;37m\]"
WHITE_UNDERLINE="\[\033[4;37m\]"
WHITE_REVERSE="\[\033[7;37m\]"

YELLOW="\[\033[0;33m\]"
YELLOW_BOLD="\[\033[1;33m\]"
YELLOW_DIM="\[\033[2;33m\]"
YELLOW_UNDERLINE="\[\033[4;33m\]"
YELLOW_REVERSE="\[\033[7;33m\]"

# General settings
# Define __git_ps1 to be nothing -- will be defined later if available
__git_ps1() { true; }
umask 0022
PS1="[${CYAN_BOLD}\u${CLEAR}@${GREEN_BOLD}\h${CLEAR} ${BLUE_BOLD}\W${CLEAR}]\$(__git_ps1 \" (%s)\")${GREEN}\$(code=\${?##0};echo \${code:+\"\[\033[01;31m\]\"}) ❯ ${CLEAR}"
export LESS=REX
export NIFS=$(printf "\n\b")
export OIFS=$IFS
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
USER_DOT_PROFILE=$HOME/.profile
[ -r $HOME/.bash_profile ] && USER_DOT_PROFILE=$HOME/.bash_profile

# General aliases
alias ls='ls -F --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
[ $(uname -s) = Linux ] && alias ls='ls -N --color=auto'
alias cdp='cd $(pwd -P)'
[ -e /dev/pf ] && alias pflog='doas tcpdump -n -e -ttt -i pflog0'
[ -e /srv/scripts/bin/nohist ] && alias nohist='source /srv/scripts/bin/nohist'
alias dos_rsync='rsync -rtcvP'
alias utcdate='TZ=UTC date "+%a %b %d %H:%M:%S %Z %Y"'
! which mail > /dev/null 2>&1 && which s-nail > /dev/null 2>&1 && alias mail=s-nail
alias printenv='printenv|sort'
alias rebashrc="source $USER_DOT_PROFILE reload"
alias reprofile="source $USER_DOT_PROFILE reload"
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

# bash vi-mode
set -o vi  # vi mode for command line editing

# Editor aliases
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

# Set some variables
which virsh > /dev/null 2>&1 && export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
if which docker > /dev/null 2>&1; then
  [ -r /srv/docker/docker-compose.yaml ] && export COMPOSE_FILE=/srv/docker/docker-compose.yaml
  [ -r /srv/docker/compose.yaml ] && export COMPOSE_FILE=/srv/docker/compose.yaml
  [ -r /srv/docker/$HOSTNAME/compose.yaml ] && export COMPOSE_FILE=/srv/docker/$HOSTNAME/compose.yaml
  [ -r /srv/containers/$HOSTNAME/compose.yaml ] && export COMPOSE_FILE=/srv/containers/$HOSTNAME/compose.yaml
  export COMPOSE_DOCKER_CLI_BUILD=0
  if docker ps --format "{{.Names}}" 2> /dev/null | grep -q "^nagios$"; then
    alias nagioscheck='docker compose exec nagios nagioscheck'
    alias nagiosreload='docker compose exec nagios nagiosreload'
  fi

  if docker ps --format "{{.Names}}" 2> /dev/null | grep -q "^nginx$"; then
    alias nginxcheck='docker compose exec nginx nginx -t'
    alias nginxreload='docker compose exec nginx nginx -s reload'
  fi

  if ! which ollama > /dev/null 2>&1 && docker ps --format "{{.Names}}" 2> /dev/null | grep -q "^ollama$"; then
    alias ollama='docker compose -f $COMPOSE_FILE exec -it ollama ollama'
  fi

  if ! which psql > /dev/null 2>&1 && docker ps --format "{{.Names}}" 2> /dev/null | grep -q "^postgres$"; then
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

  if docker ps --format "{{.Names}}" 2> /dev/null | grep -Eq "^(mysql|mariadb)$"; then
    which mariadb > /dev/null 2>&1 || alias mariadb="docker compose exec -it -u mysql mysql mariadb"
    which mariadb-dump > /dev/null 2>&1 || alias mariadb-dump="docker compose exec -it -u mysql mysql mariadb-dump"
  fi
fi

# Ansible aliases
if which ansible-playbook > /dev/null 2>&1; then
  alias ap=ansible-playbook
  alias apv='ansible-playbook --ask-vault-pass'
  alias apkv='ANSIBLE_SSH_ARGS="-o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook --ask-vault-pass'
  alias apk='ANSIBLE_SSH_ARGS="-o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook'
  export ANSIBLE_NOCOWS=1
fi

# RPI commands
which vcgencmd > /dev/null 2>&1 && alias gettemp='echo $(echo "$(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}")*9/5+32" | bc) F'
which vcgencmd > /dev/null 2>&1 && alias gettempc='echo $(vcgencmd measure_temp | awk -F"[='"'"']" "{print \$2}") C'

# sudo/doas aliases
# The space after mysudo (or sudo) allows for alias expansion in sudo
alias sudo='sudo '
which sudo > /dev/null 2>&1
ret_sudo=$?
which doas > /dev/null 2>&1
ret_doas=$?
[ $ret_sudo != 0 -a $ret_doas = 0 ] && alias sudo='doas '
[ $ret_sudo = 0 -a $ret_doas != 0 ] && alias doas='sudo '

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

# Handle with / is read-only
if [ -r /boot/cmdline.txt ] && grep -qE "\<ro\>" /boot/cmdline.txt; then
  alias check_root='sudo lsof / | awk "NR==1 || \$4~/[0-9]+[uw]/"'
fi

# Set other PATH files
export CARGO_HOME=$XDG_DATA_HOME/cargo
export DEAD=$XDG_CACHE_HOME/dead.letter
export GNUPGHOME=$XDG_DATA_HOME/gnupg
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
  [ -e $HOME/.config/tmux/tmux.conf.remain ] && \
    alias remain='tmux -f $HOME/.config/tmux/tmux.conf.remain new-session -A -s main'

  if [ "${HOSTNAME%%.*}" = mercury ] && [ "${SSH_CLIENT%% *}" = 192.168.25.38 -o "${SSH_CLIENT%% *}" = 192.168.25.38 ]; then
    alias tmux='ssh carme tmux'
  fi
fi

# Git stuff
if which git > /dev/null 2>&1; then
  if echo $SHELL | grep -Eq "^.*/bash$" || echo $SHELL | grep -Eq "^.*/ksh$"; then
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWCOLORHINTS=true
    [ -e /usr/lib/git-core/git-sh-prompt ] && source /usr/lib/git-core/git-sh-prompt
    [ -e /usr/share/git/completion/git-prompt.sh ] && source /usr/share/git/completion/git-prompt.sh
    [ -e $HOME/bin/git-prompt.sh ] && source $HOME/bin/git-prompt.sh
  fi
  if ! pgrep -x gpg-agent > /dev/null 2>&1; then
    export GPG_TTY=$(tty)
  fi
fi

# History stuff (needs to come after Git stuff)
HISTFILESIZE=10000
HISTSIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTFILE=$XDG_CACHE_HOME/shell_history
if echo $SHELL | grep -Eq "^(/usr(/local)?)?/bin/bash$"; then
  bind 'set show-mode-in-prompt on'
  #bind 'set vi-cmd-mode-string "[N]"'
  #bind 'set vi-ins-mode-string "[I]"'
  bind 'set vi-ins-mode-string \1\e[6 q\2'
  bind 'set vi-cmd-mode-string \1\e[2 q\2'

  shopt -s extglob
  shopt -s histappend
  # Try to do a shared command history
  if [ -z "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="history -a; history -c; history -r"
  elif ! echo ";$PROMPT_COMMAND;" | grep -qE "; ?history -a; ?history -c; ?history -r ?;"; then
    PROMPT_COMMAND="$PROMPT_COMMAND; history -a; history -c; history -r"
  fi
  if which fzf &> /dev/null; then
    if fzf --help | grep -q -- " --bash "; then
      eval "$(fzf --bash)"
    else
      source /usr/share/doc/fzf/examples/key-bindings.bash
    fi
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
    if which paru > /dev/null 2>&1; then
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
    alias updates='doas syspatch ; doas pkg_add -u'

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

[ -e $HOME/.profile.local ] && source $HOME/.profile.local

# Wayland stuff
if [ "$XDG_SESSION_TYPE" = wayland ]; then
  export SSH_ASKPASS=$HOME/bin/yad-askpass
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
fi

# Wayland stuff over SSH
if [ "$ID" != OpenBSD ] && [ -n "$SSH_CONNECTION" ]; then
  WAYLAND_DISPLAY_FILE=$(find $XDG_RUNTIME_DIR -maxdepth 1 -regex ".*/wayland-[0-9]+")
  if [ -n "$WAYLAND_DISPLAY_FILE" ]; then
    export XDG_SESSION_TYPE=wayland
    export WAYLAND_DISPLAY=$(basename "$WAYLAND_DISPLAY_FILE")

    if which niri > /dev/null 2>&1; then
      NIRI_SOCKET=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "niri.wayland-*.sock")
      [ -n "$NIRI_SOCKET" ] && export NIRI_SOCKET
    fi

    if which hyprctl > /dev/null 2>&1; then
      HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl -j instances 2>/dev/null | jq -r '.[-1].instance' 2> /dev/null)
      [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && export HYPRLAND_INSTANCE_SIGNATURE
    fi

    if which swaymsg > /dev/null 2>&1; then
      SWAYSOCK=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "sway-ipc.*.*.sock")
      [ -n "$SWAYSOCK" ] && export SWAYSOCK
    fi
  fi
fi
