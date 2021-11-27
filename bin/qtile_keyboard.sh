#!/bin/sh

pgrep -x onboard -u $LOGNAME > /dev/null && pkill -x onboard -u $LOGNAME || onboard -a > /dev/null 2>&1 &
