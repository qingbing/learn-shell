#!/bin/bash
# This is a monitor

# web监控
nc -w 3 localhost 80 &> /dev/null

if [ $? -eq 0 ]; then
    str="Web is normal."
else
    str="Web is closed or no answer."
fi

# 硬mysql监控
nc -w 3 localhost 3306 &> /dev/null

if [ $? -eq 0 ]; then
    str=$str"<br>Mysql is normal."
else
    str=$str"<br>Mysql is closed or no answer."
fi

# 硬盘监控
ds=`df | awk '{if(NR==2){print int($5)}}'`
if [ $ds -lt 60 ]; then
    str=$str"<br>disk space ${ds} is normal."
else
    str=$str"<br>disk space ${ds} is busy."
fi

# 内存监控
# used=`free -m | awk '{if(NR==2){print $3}}'`
# total=`free -m | awk '{if(NR==2){print $2}}'`
# percent=$(($used*100/$total))


percent=`free -m | awk '{if(NR==2){print int($3*100/$2)}}'`

if [ $percent -lt 60 ]; then
    str=$str"<br>memory space ${fs} is normal."
else
    str=$str"<br>memory space ${fs} is busy."
fi

echo -e $str


echo $str | mail -s "monitor" 780042175@qq.com
