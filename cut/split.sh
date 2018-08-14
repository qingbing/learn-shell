#!/bin/bash
# cut nginx log

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
yesterday=$(date -d yesterday +%Y%m%d)

srcLogFile="${CURDIR}/log/access.${yesterday}.log"


tmpfile=$$.txt
mc="/usr/local/product/mysql-5.5.41/bin/mysql -uroot -p111111"

cat ${srcLogFile} | awk '{print $1}' | sort | uniq -c | awk '{print $2":"$1}' > $tmpfile
for line in `cat ${tmpfile}`; do
    ip=$(echo $line | awk -F: '{print $1}')
    num=$(echo $line | awk -F: '{print $2}')
    sql="INSERT INTO test.webcount SET ip='${ip}', date='${yesterday}', num='${num}';"
    $mc -e "$sql"
done

rm -f $tmpfile &> /dev/null
