#!/bin/sh
# check_ip.sh | check external ip and modify a file if it has been changed
# requires a volume mounted to /var/checks
# 2025-02-13 brandon teel | brandon.teel@telus.com
# 2025-04-27 - added some extra functions for later, liveness check

CHECK_DIR="/var/checks"
OLD_IP=""
CURR_DATE=`date -Iseconds`
NEW_IP=`curl -s ipv4.icanhazip.com`

mkdir -p ${CHECK_DIR}/check_ip
mkdir -p ${CHECK_DIR}/still_alive


echo "$CURR_DATE" > ${CHECK_DIR}/still_alive/still_alive

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

if [ -f ${CHECK_DIR}/check_ip/check_ip ]; then
    OLD_IP=`cat ${CHECK_DIR}/check_ip/check_ip`
fi

if [ "$NEW_IP" != "$OLD_IP" ]; then
    echo "$NEW_IP" > ${CHECK_DIR}/check_ip/check_ip
    msg "IP changed: ${OLD_IP} => ${NEW_IP}"
else
    msg "IP not changed: ${NEW_IP}"
fi

exit 0