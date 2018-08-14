#!/bin/bash
# cut nginx log

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
yesterday=$(date -d yesterday +%Y%m%d)

PID=$(cat /usr/local/product/nginx/logs/nginx.pid)
srcLog="/usr/local/product/nginx/logs"
targetLog="${CURDIR}"

# move log
mv ${srcLog}/access.log ${targetLog}/log/access.${yesterday}.log
mv ${srcLog}/error.log ${targetLog}/log/error.${yesterday}.log

# sent a signal to reopen logfile of nginx
kill -HUP ${PID}
