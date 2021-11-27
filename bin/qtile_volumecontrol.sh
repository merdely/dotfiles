#!/bin/sh

pgrep -x pavucontrol -u $LOGNAME > /dev/null && pkill -x pavucontrol -u $LOGNAME || pavucontrol > /dev/null 2>&1 &
