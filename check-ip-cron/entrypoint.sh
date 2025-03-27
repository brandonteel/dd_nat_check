#!/bin/sh

/usr/sbin/start-cron '\*/5 \* \* \* \* /check_ip.sh >> /var/log/cron.log 2>&1'

exit $?