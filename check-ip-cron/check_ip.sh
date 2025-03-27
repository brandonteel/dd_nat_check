#!/bin/sh
# check_ip.sh | check external ip and modify a file if it has been changed
# requires a volume mounted to /var/check_ip
# 2025-02-13 brandon teel | brandon.teel@telus.com

HEALTHCHECK_PORT=$1
CHECK_FILE="/var/check_ip/check_ip"
OLD_IP=""
CURR_DATE=`date -Iseconds`
NEW_IP=`curl -s ipv4.icanhazip.com || err "Can't get current NAT IP" "1"`

function printmsg(){
    status="$1"
    message="$2"
    printf "[%s][%s][%s] %s\n" "$CURR_DATE" "check_ip" "$status" "$message"
}

function err(){
    message="$1"
    exitcode="$2"
    printmsg "ERROR" "$message" 1>&2
    rm -f /STATUS_OK
    echo "$exitcode" > /STATUS_ERR
    exit $exitcode
}

function msg(){
    message="$*"
    printmsg "OK" "$message"
}

curl http://127.0.0.1:${HEALTHCHECK_PORT} >/dev/null || \
err "HTTP server not serving healthcheck at port ${HEALTHCHECK_PORT}" "2"


if [ -f $CHECK_FILE ]; then
    OLD_IP=`cat $CHECK_FILE`
else
    touch "$CHECK_FILE" || err "Check file not accessible" "3"
fi

if [ "$NEW_IP" != "$OLD_IP" ]; then
    echo "$NEW_IP" > $CHECK_FILE
    msg "IP changed: ${OLD_IP} => ${NEW_IP}"
else
    msg "IP not changed: ${NEW_IP}"
fi

exit 0