#!/bin/sh
#set -e

sleep ${SHUTDOWN_SECONDS} && /bin/killscript.sh &
/bin/entrypoint.sh