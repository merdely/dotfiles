#!/bin/sh

# Only prompt for SSH Key Passprase if SSH Agent doesn't already have it
env SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket ssh-add -l > /dev/null || \
  { sleep 4; env SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket /usr/bin/ssh-add < /dev/null; date "+%F %T: unlocking ssh key" >> /tmp/autostart_$LOGNAME.log; } & 

pgrep -u $LOGNAME -x qtile > /dev/null && qtile run-cmd -g 1 x-terminal-emulator &
