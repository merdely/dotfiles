## Mike's Master merdely.profile

# Define running shell and exit if not bash, zsh, or ksh
running_shell=unknown
[ ${SHELL##*/} = bash -o -n "$BASH_VERSION" ] && running_shell=bash
[ ${SHELL##*/} = zsh -o -n "$ZSH_VERSION" ] && running_shell=zsh
[ ${SHELL##*/} = ksh -o -n "$KSH_VERSION" ] && running_shell=ksh
[ $running_shell = unknown ] && return

# Add '[[ $- == *i* ]] && [ -r $HOME/.config/shell/merdely.profile ] && . $HOME/.config/shell/merdely.profile'
# to the bottom of $HOME/.profile or $HOME/.bashrc

# Set umask early
umask 0022

# Set kernel_name so we don't run 'uname -s' several times
[ -r /etc/os-release ] && . /etc/os-release
kernel_name=$(uname -s)
[ -z "$ID" ] && export ID=$kernel_name

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

# Used in aliases below
[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname -s)"
export HOSTNAME=${HOSTNAME%%.*}

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

# Use 'command -v' instead of which with bash and zsh
[ $running_shell != ksh ] && alias which='command -v'

# Git stuff
if which git > /dev/null 2>&1; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWCOLORHINTS=true
  [ -e /usr/lib/git-core/git-sh-prompt ] && . /usr/lib/git-core/git-sh-prompt
  [ -e /usr/share/git/completion/git-prompt.sh ] && . /usr/share/git/completion/git-prompt.sh
  [ -e $HOME/.local/bin/git-prompt.sh ] && . $HOME/.local/bin/git-prompt.sh
  [ -e $HOME/bin/git-prompt.sh ] && . $HOME/bin/git-prompt.sh
  if ! pgrep -x gpg-agent > /dev/null 2>&1; then
    export GPG_TTY=$(tty)
  fi
fi

# History stuff
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoreboth
HISTFILE=$XDG_CACHE_HOME/shell_history
user_dot_profile=$HOME/.profile
[ -r $HOME/.bash_profile ] && user_dot_profile=$HOME/.bash_profile

pcharr_user_text='>'
pcharl_user_text='<'
pcharr_root_text='>>'
pcharl_root_text='<<'
gchar_text=''
pcharr_user_gui='❱'
pcharl_user_gui='❰'
pcharr_root_gui='≫'
pcharl_root_gui='≪'
gchar_gui=' '

if [ $running_shell = bash -o $running_shell = ksh ]; then
  HISTCONTROL=ignoreboth:erasedups
  shopt -s autocd cdspell extglob histappend
  PROMPT_DIRTRIM=2

  # \1 & \2 are good for the vi-ins-mode-string but \[ and \] are good for PS1
  # Colors: black:30, blue:34, cyan:36, green:32, purple:35, red:31, white:37, yellow:33
  #         orange:38;2;255;165;0 (foreground:38, background:48)
  # Set up prompt

  show_vi_mode=0
  [ -r $XDG_CONFIG_HOME/shell/show_vi_mode ] && show_vi_mode=1
  if [ $show_vi_mode = 1 ]; then
    bind 'set show-mode-in-prompt on'
    bind 'set keymap vi-insert'
    PS1=' '
  fi
  __update_prompt () {
    ec=32
    [ "$1" != 0 ] && ec=31

    if [[ $TERM == xterm* ]] || [[ $TERM == tmux* ]] || [[ $TERM == screen* ]]; then
      pcharr=$pcharr_user_gui && pcharl=$pcharl_user_gui && gchar=$gchar_gui
      [ $UID = 0 ] && pcharr=$pcharr_root_gui && pcharl=$pcharl_root_gui
    else
      pcharr=$pcharr_user_text && pcharl=$pcharl_user_text && gchar=$gchar_text
      [ $UID = 0 ] && pcharr=$pcharr_root_text && pcharl=$pcharl_root_text
    fi
    local EMBEDDED_PS1='[\[\e[1;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]]$(__git_ps1 " (\[\e[38;2;255;165;0m\]${gchar}\[\e[0m\]%s)" 2> /dev/null)\[\e[${ec}m\]'
    if [ $show_vi_mode = 0 ]; then
      PS1=${EMBEDDED_PS1}' '${pcharr}'\[\e[0m\] '
    else
      EMBEDDED_PS1=${EMBEDDED_PS1//\\[/\\1}
      EMBEDDED_PS1=${EMBEDDED_PS1//\\]/\\2}
      bind "set vi-ins-mode-string \"${EMBEDDED_PS1@P} ${pcharr}\1\e[0m\2\""
      bind "set vi-cmd-mode-string \"${EMBEDDED_PS1@P} ${pcharl}\1\e[0m\2\""
    fi
  }
  __update_prompt
  PROMPT_COMMAND="code=\$?;__update_prompt \$code;unset code;history -a; history -c; history -r"
  command -v fzf > /dev/null 2>&1 && eval "$(fzf --bash)"
  if command -v fzf > /dev/null 2>&1; then
    type __fzf_history__ > /dev/null 2>&1 || eval "$(fzf --zsh)"
  fi

  # bash vi-mode
  set -o vi  # vi mode for command line editing
elif [ $running_shell = zsh ]; then
  zmodload zsh/complist
  autoload -U compinit && compinit
  autoload -U colors && colors
  autoload -U edit-command-line && zle -N edit-command-line
  edit-and-execute() {
    zle edit-command-line
    zle accept-line
  }
  zle -N edit-and-execute
  bindkey -M vicmd '^v' edit-and-execute

  #zstyle ':completion:*' menu select # tab opens cmp menu
  zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
  # zstyle ':completion:*' file-list true # more detailed list
  zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

  SAVEHIST=$HISTFILESIZE
  HISTFILE=$XDG_CACHE_HOME/zsh_history
  user_dot_profile=$HOME/.config/zsh/.zshrc

  # main opts
  setopt append_history inc_append_history share_history # better history
  # on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
  setopt auto_menu menu_complete # autocmp first menu match
  setopt autocd # type a dir to cd
  setopt auto_pushd # push the old directory into the directory stack
  setopt cd_silent # don't print dir
  setopt pushd_silent # don't print dir
  setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
  setopt no_case_glob no_case_match # make cmp case insensitive
  setopt globdots # include dotfiles
  setopt extended_glob # match ~ # ^
  setopt interactive_comments # allow comments in shell
  unsetopt prompt_sp # don't autoclean blanklines
  stty stop undef # disable accidental ctrl s

  use_starship=1
  if { [[ $TERM == xterm* ]] || [[ $TERM == tmux* ]] || [[ $TERM == screen* ]]; } && \
     [ "$use_starship" = 1 ] && which starship > /dev/null 2>&1 && [ -r $HOME/.config/starship.toml ]; then
    type starship_zle-keymap-select > /dev/null 2>&1 || eval "$(starship init zsh)"
  else
    setopt PROMPT_SUBST
    __set_prompt() {
      if [[ $TERM == xterm* ]] || [[ $TERM == tmux* ]] || [[ $TERM == screen* ]]; then
        pcharr=$pcharr_user_gui && pcharl=$pcharl_user_gui && gchar=$gchar_gui
        [ $UID = 0 ] && pcharr=$pcharr_root_gui && pcharl=$pcharl_root_gui
      else
        pcharr=$pcharr_user_text && pcharl=$pcharl_user_text && gchar=$gchar_text
        [ $UID = 0 ] && pcharr=$pcharr_root_text && pcharl=$pcharl_root_text
      fi
      pchar=$pcharr
      [[ $KEYMAP = vicmd ]] && pchar=$pcharl
      PROMPT='[%B%F{cyan}%n%b%f@%B%F{green}%m%f%b %B%F{blue}%2~%f%b]$(__git_ps1 " (${gchar}%s)" 2>/dev/null) %(?.%F{green}.%F{red})${pchar}%f '
    }
    __set_prompt

    # When sharing this config with bash, it does not like the "function name1 name2 ()" definition
    # Set the prompt automatically
    zle-line-init() { __set_prompt; zle reset-prompt; }
    zle-keymap-select() { __set_prompt; zle reset-prompt; }
    zle -N zle-line-init
    zle -N zle-keymap-select
  fi

  bindkey -v
  bindkey -M vicmd j vi-down-line-or-history
  bindkey -M vicmd k vi-up-line-or-history

  if command -v fzf > /dev/null 2>&1; then
    type fzf-history-widget > /dev/null 2>&1 || eval "$(fzf --zsh)"
  fi

  hash -d bin=$HOME/.local/bin
  hash -d config=$XDG_CONFIG_HOME
  hash -d shell=$XDG_CONFIG_HOME/shell

  # Use XDG dirs for completion and history files
  [ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
  zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
  compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

  # ZSH Syntax Highlighting
  [ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # ZSH Auto Suggestions
  [ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
  bindkey -M viins '^y' autosuggest-execute
  bindkey -M viins "^Xy" autosuggest-accept

  # Really breaks vi-mode history searching
  #[ -r /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ] && \
  #  source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  #bindkey -M vicmd "j" vi-down-line-or-history
  #bindkey -M vicmd "k" vi-up-line-or-history
  #bindkey -M vicmd "/" vi-history-search-backward
fi

# General settings
export LESS=REX
export NIFS=$(printf "\n\b")
export OIFS=$IFS
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
add_to_path -b $HOME/.local/bin
add_to_path -e /usr/sbin
[ -d /srv/scripts/bin ]  && add_to_path -e /srv/scripts/bin
[ -d /srv/scripts/sbin ] && add_to_path -e /srv/scripts/sbin
[ -z "$EUID" ] && export EUID=$(id -u)
[ -x /usr/lib/nagios/plugins/check_disk ] && add_to_path /usr/lib/nagios/plugins

# General aliases
alias reprofile=". $user_dot_profile reload"
alias cdp='cd $(pwd -P)'
alias ls='ls -F'
[ $kernel_name = Linux ] && alias ls='ls -N --color=auto'
[ $kernel_name = Linux ] && alias grep='grep --color=auto'
[ $kernel_name = Linux ] && alias diff='diff --color=auto'
[ -e /dev/pf ] && alias pflog='doas tcpdump -n -e -ttt -i pflog0'
[ -e /srv/scripts/bin/nohist ] && alias nohist='. /srv/scripts/bin/nohist'
! which mail > /dev/null 2>&1 && which s-nail > /dev/null 2>&1 && alias mail=s-nail
alias check_reboot='sudo /srv/scripts/sbin/daily_report_linux reboot'
alias check_restart='sudo /srv/scripts/sbin/daily_report_linux restart'
[ -d /opt/splunk -o -d /opt/splunkforwarder ] && alias susplunk='sudo su - splunk'
[ -d /etc/acme ] && alias suacme='sudo su - -s /bin/bash -l acme'
which python2 > /dev/null 2>&1 && alias python=python2
which python3 > /dev/null 2>&1 && alias python=python3
which rsync > /dev/null 2>&1 && alias dos_rsync='rsync -rtcvP'
which batman > /dev/null 2>&1 && eval "$(batman --export-env)"
which bat > /dev/null 2>&1 && alias cat='bat --paging=never --plain'
which bat > /dev/null 2>&1 && export PAGER='bat'
# Window Manager aliases
which Hyprland > /dev/null 2>&1 && alias hhh='Hyprland'
which niri-session > /dev/null 2>&1 && alias nnn='niri-session'
which sway > /dev/null 2>&1 && alias sss='sway'

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
alias vip='vi $HOME/.config/shell/merdely.profile'
which hyprctl > /dev/null 2>&1 && alias vih='vi -O $HOME/.config/hypr/hyprland.conf'
which hyprctl > /dev/null 2>&1 && alias vihl='vi $HOME/.config/local/hyprland.conf'
which hyprctl > /dev/null 2>&1 && alias vihb='vi -O $HOME/.config/hypr/hyprland.conf $HOME/.config/local/hyprland.conf'
which i3-msg  > /dev/null 2>&1 && alias vi3='vi $HOME/.config/i3/config'
which swaymsg > /dev/null 2>&1 && alias vis='vi $HOME/.config/sway/config'
which niri    > /dev/null 2>&1 && alias vin='vi $HOME/.config/niri/config.kdl'
which nvim    > /dev/null 2>&1 && alias viv='vi $HOME/.config/nvim/init.lua'

# DNS Command aliases
if which dog > /dev/null 2>&1; then
  which dig > /dev/null 2>&1 || alias dig=dog
  which host > /dev/null 2>&1 || alias host=dog
fi

# Set some variables
which virsh > /dev/null 2>&1 && export VIRSH_DEFAULT_CONNECT_URI=qemu:///system
if which docker > /dev/null 2>&1; then
  [ -r /srv/docker/docker-compose.yaml ] && export COMPOSE_FILE=/srv/docker/docker-compose.yaml
  [ -r /srv/docker/compose.yaml ] && export COMPOSE_FILE=/srv/docker/compose.yaml
  export COMPOSE_DOCKER_CLI_BUILD=0
  alias dc='docker compose'
  if [ -d /srv/docker/naemon ]; then
    alias naemoncheck='docker compose exec naemon runuser -u naemon -- naemon -v /etc/naemon/naemon.cfg'
    alias naemonreload='docker compose exec naemon pkill -P 1 -x naemon'
  fi

  if [ -d /srv/docker/nagios ]; then
    alias nagioscheck='docker compose exec nagios nagioscheck'
    alias nagiosreload='docker compose exec nagios nagiosreload'
  fi

  if [ -d /srv/docker/nginx ]; then
    alias nginxcheck='docker compose exec nginx nginx -t'
    alias nginxreload='docker compose exec nginx nginx -s reload'
  fi

  if ! which ollama > /dev/null 2>&1 && [ -d /srv/docker/ollama ]; then
    alias ollama='docker compose -f $COMPOSE_FILE exec -it ollama ollama'
  fi

  if ! which psql > /dev/null 2>&1 && [ -d /srv/docker/postgres ]; then
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

  if [ -d /srv/docker/mysql ]; then
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

# sudo/doas aliases
# The space after sudo/mysudo allows for alias expansion in sudo
which sudo > /dev/null 2>&1
ret_sudo=$?
which doas > /dev/null 2>&1
ret_doas=$?
[ $ret_sudo = 0 ] && alias sudo='sudo '
[ $ret_sudo != 0 -a $ret_doas = 0 ] && alias sudo='doas '
[ $ret_sudo = 0 -a $ret_doas != 0 ] && alias doas='sudo '
if [ $ret_sudo = 0 ] && [ -x /srv/scripts/bin/sudo_with_sudoedit ]; then
  alias sudo='/srv/scripts/bin/sudo_with_sudoedit '
  [ $ret_sudo = 0 -a $ret_doas != 0 ] && alias doas='/srv/scripts/bin/sudo_with_sudoedit '
fi

# Handle with / is read-only
if [ -r /boot/cmdline.txt ] && grep -qE "\<ro\>" /boot/cmdline.txt; then
  alias check_root='sudo lsof / | awk "NR==1 || \$4~/[0-9]+[uw]/"'
fi

# Configuration settings to not pollute $HOME
# XDG_CONFIG_HOME ($HOME/.config)
export ANSIBLE_CONFIG=$XDG_CONFIG_HOME/ansible.cfg
export ANSIBLE_HOME=$XDG_CONFIG_HOME/ansible
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export WGETRC=$XDG_CONFIG_HOME/wget/wgetrc
export PSQLRC=$XDG_CONFIG_HOME/pg/psqlrc
# XDG_CACHE_HOME $($HOME/.cache)
export ANSIBLE_GALAXY_CACHE_DIR=$XDG_CACHE_HOME/ansible/galaxy_cache
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv
export DEAD=$XDG_CACHE_HOME/dead.letter
export LESSHISTFILE=$XDG_CACHE_HOME/less-history
export MYSQL_HISTFILE=$XDG_CACHE_HOME/mysql_history
export PSQL_HISTORY=$XDG_CACHE_HOME/psql_history
export PYTHON_HISTORY=$XDG_CACHE_HOME/python-history
export SQLITE_HISTORY=$XDG_CACHE_HOME/sqlite_history
# XDG_STATE_HOME ($HOME/.local/state)
export CARGO_HOME=$XDG_STATE_HOME/cargo
export DVDCSS_CACHE=$XDG_STATE_HOME/dvdcss
export GNUPGHOME=$XDG_STATE_HOME/gnupg
# XDG_DATA_HOME ($HOME/.local/share)
export ELECTRUMDIR=$XDG_DATA_HOME/electrum
export GOPATH=$XDG_DATA_HOME/go
export GOBIN=$XDG_DATA_HOME/go/bin
export LEIN_HOME=$XDG_DATA_HOME/lein
export MACHINE_STORAGE_PATH=$XDG_DATA_HOME/docker-machine
export VSCODE_PORTABLE=$XDG_DATA_HOME/vscode
# XDG_RUNTIME_DIR (/run/user/1000 or /tmp/.1000)
export SCREENDIR=$XDG_RUNTIME_DIR/screen

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

        pushprofile() {
          cd $HOME
          list="pluto jupiter earth carme metis sinope tarvos"
          [ -n "$1" ] && list="$@"
          unset ros
          roh=" carme metis sinope tarvos "
          for f in $(echo $list); do
            echo $f
            out=$(rsync -a --info=NAME --relative --recursive \
              .config/shell/merdely.profile .config/starship.toml $f: 2>&1 | tee /dev/stderr)
            [ -n "$out" ] && [[ $roh == *" "$f" "* ]] && ros="$ros $f"
          done
          for f in $(echo $ros); do
            echo $f: sync_home
            ssh -o ClearAllForwardings=yes root@$f /home/mike/.local/bin/sync_home > /dev/null
          done
        }

        pushknownhosts() {
          list="pluto jupiter mercury earth"
          [ -n "$1" ] && list="$@"
          for f in $(echo $list); do
            echo $f
            scp $HOME/src/ansible/system-setup/roles/sshclient/files/ssh_known_hosts \
              root@$f:/etc/ssh/ssh_known_hosts
          done
          for f in carme metis tarvos; do
            echo $f
            ssh -o ClearAllForwardings=yes root@$f /usr/local/bin/rw
            scp $HOME/src/ansible/system-setup/roles/sshclient/files/ssh_known_hosts \
              root@$f:/etc/ssh/ssh_known_hosts
            ssh -o ClearAllForwardings=yes root@$f /usr/local/bin/ro
          done
        }

        pushvimrc() {
          cd $HOME
          list="jupiter earth pluto carme metis sinope tarvos"
          [ -n "$1" ] && list="$@"
          unset ros
          roh=" carme metis sinope tarvos "
          for f in $(echo $list); do
            echo $f
            out=$(rsync -a --info=NAME --relative --recursive \
              .config/vim/vimrc $f: 2>&1 | tee /dev/stderr)
            [ -n "$out" ] && [[ $roh == *" "$f" "* ]] && ros="$ros $f"
          done
          for f in $(echo $ros); do
            echo $f: sync_home
            ssh -o ClearAllForwardings=yes root@$f /home/mike/.local/bin/sync_home > /dev/null
          done
        }
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
    alias ru='sudo reflector -c US -p https -f 5 --sort rate --save /etc/pacman.d/reflector.list'
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
    alias updates="echo running syspatch; doas syspatch; echo running pkg_add -u; doas pkg_add -ui"

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

[ -e $HOME/.config/shell/profile.local ] && . $HOME/.config/shell/profile.local

# Wayland stuff
if [ "$XDG_SESSION_TYPE" = wayland ]; then
  export SSH_ASKPASS=$HOME/.local/bin/yad-askpass
  export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
fi

# Wayland stuff over SSH
if [ "$ID" != OpenBSD ] && [ -z "$SUDO_USER" ] && [ -z "$DOAS_USER" ] && [ -n "$SSH_CONNECTION" ]; then
  WAYLAND_DISPLAY_FILE=$(find $XDG_RUNTIME_DIR -maxdepth 1 -regex ".*/wayland-[0-9]+")
  if [ -n "$WAYLAND_DISPLAY_FILE" ]; then
    export XDG_SESSION_TYPE=wayland
    export WAYLAND_DISPLAY=$(basename "$WAYLAND_DISPLAY_FILE")

    if which swaymsg > /dev/null 2>&1; then
      SWAYSOCK=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "sway-ipc.*.*.sock")
      [ -n "$SWAYSOCK" ] && export SWAYSOCK
      export XDG_CURRENT_DESKTOP=sway
    fi

    if which hyprctl > /dev/null 2>&1; then
      HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl -j instances 2>/dev/null | jq -r '.[-1].instance' 2> /dev/null)
      [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && export HYPRLAND_INSTANCE_SIGNATURE
      export XDG_CURRENT_DESKTOP=Hyprland
    fi

    if which niri > /dev/null 2>&1; then
      NIRI_SOCKET=$(find $XDG_RUNTIME_DIR -maxdepth 1 -name "niri.wayland-*.sock")
      [ -n "$NIRI_SOCKET" ] && export NIRI_SOCKET
      export XDG_CURRENT_DESKTOP=niri
    fi

  fi
fi

true
