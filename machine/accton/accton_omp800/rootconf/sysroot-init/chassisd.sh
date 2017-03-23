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

chassisd_dir=/usr/local/accton/bin
[ -d $chassisd_dir ] || {
    echo "ERROR: Chassis daemon directory not found: $chassisd_dir"
    exit 1
}

cd $chassisd_dir
for f in chassis chassis_client chassis.conf ; do
    ln -f r$onie_machine_rev/$f $f
done

case $cmd in
    start)
        killall $daemon > /dev/null 2>&1
        log_begin_msg "Starting: $daemon"
        ifconfig lo up
        cd $chassisd_dir && ./$daemon $ARGS > /dev/null 2>&1
        log_end_msg
        ;;
    stop)
        log_begin_msg "Stopping: $daemon"
        killall $daemon > /dev/null 2>&1
        log_end_msg
        ;;
    *)
        
esac
