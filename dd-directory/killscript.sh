#!/bin/sh

PID=`ps x | sed -E "s/^\s+//" | grep s6-svscan | cut -d' ' -f1 | head -n1`

echo "Shutting down..."

kill ${PID}
if [ $? != 0 ]; then
    echo "Could not shut down gracefully, attempting to force" 1>&2
    kill -9 ${PID}
    if [ $? != 0 ]; then
        echo "Failed to force shutdown, waiting for timeout" 1>&2
    fi
fi