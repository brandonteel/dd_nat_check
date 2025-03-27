#!/usr/bin/env bash
set -euo pipefail

cron 
tail -f /var/log/cron.log 2>&1 &

exit 0