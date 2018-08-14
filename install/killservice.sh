#!/bin/bash
# kill httpd

# $$ : 获取当前脚本执行时的PID

# 1、获取所有httpd应用程序的进程号
# 2、把进程号存入一个临时文件中
# 3、从临时文件中读取所有的进程号（apache）
# 4、使用 for in循环用kill 杀掉所有的httpd进程
# 5、删除之前生成的临时文件
# 6、输出关闭进程后的消息

tmpfile=$$.txt

ps -e | grep 'httpd' | awk '{print $1}' >> $tmpfile
for pid in `cat ${tmpfile}`; do
    kill -9 ${pid}
    echo "appche ${pid} is killed."
done

sleep 1
rm -f ${tmpfile}
echo "apache has been closed."