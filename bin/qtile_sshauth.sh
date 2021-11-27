#!/bin/sh
export SSH_AUTH_SOCK=$HOME/.ssh/ssh-auth-sock

ssh-add -l > /dev/null 2>&1
if [ $? = 0 ]; then
  printf "🟢"
else
  printf "🟥"
fi

