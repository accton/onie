#!/bin/sh
#
#  Copyright (C) 2016 david_yang <david_yang@accton.com>
#
#  SPDX-License-Identifier:     GPL-2.0

cmd="$1"

PATH=/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/accton/bin

. /lib/onie/functions

daemon="chassis"
ARGS=""

case $cmd in
    start)
        killall $daemon > /dev/null 2>&1
        log_begin_msg "Starting: $daemon"
        cd / && $daemon $ARGS > /dev/null 2>&1
        log_end_msg
        ;;
    stop)
        log_begin_msg "Stopping: $daemon"
        killall $daemon > /dev/null 2>&1
        log_end_msg
        ;;
    *)
        
esac
