#!/bin/sh
# check_ip.sh | check external ip and modify a file if it has been changed
# requires a volume mounted to /var/check_ip
# 2025-02-13 brandon teel | brandon.teel@telus.com

CHECK_FILE="/var/check_ip/check_ip"
NEW_IP=`curl -s icanhazip.com`
OLD_IP=""
CURR_DATE=`date -Iseconds`

function msg(){
    message="$*"
    printf "[%s][%s] %s\n" "$CURR_DATE" "check_ip" "$message"
}

if [ -f $CHECK_FILE ]; then
    OLD_IP=`cat $CHECK_FILE`
fi

if [ "$NEW_IP" != "$OLD_IP" ]; then
    echo "$NEW_IP" > $CHECK_FILE
    msg "IP changed: ${OLD_IP} => ${NEW_IP}"
else
    msg "IP not changed: ${NEW_IP}"
fi

exit 0