#!/bin/sh

RUN_TIME="$1"
HEALTHCHECK_PORT="$2"
MAX_RETRIES="$3"

sed -i "s/\{\{HEALTHCHECK_PORT\}\}/${HEALTHCHECK_PORT}/" /etc/lighttpd/lighttpd.conf

touch "/STATUS_OK"

/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
/usr/sbin/start-cron -m "${MAX_RETRIES}" '\*/5 \* \* \* \* /check_ip.sh '"$HEALTHCHECK_PORT"' >> /var/log/cron.log 2>&1'

exit $?