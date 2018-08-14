#!/bin/bash
# backup.sh

# 常用变量
date=$(date '+%Y-%m-%d')
backDir="/mnt/${date}"
webDir="/data/web/test.us"

back_webDir="${backDir}/web"
back_dataDir="${backDir}/data"

mc="/usr/local/product/mysql-5.5.41/bin/mysqldump -uroot -p111111 test"

# 创建目录
mkdir -p $backDir
mkdir -p $back_webDir
mkdir -p $back_dataDir

# 复制目录网站
rsync -r $webDir $back_webDir &>/dev/null
if [ $? -eq 0 ]; then
    echo "web backup ok!"
else
    echo -e "\033[31,47mweb backup failly\033[0m"
fi

# 导出数据sql语句
$mc > "${back_dataDir}/test.sql"
if [ $? -eq 0 ]; then
    echo "data backup ok!"
else
    echo -e "\033[31,47mdata backup failly\033[0m"
fi

pwd

# 目标目录压缩
cd /mnt
tar -czf "${date}.tar.gz" $date &>/dev/null
if [ $? -eq 0 ]; then
    echo "tar create ok!"
else
    echo -e "\033[31,47mtar create failly\033[0m"
fi


# 源目录删除完成
rm -rf $backDir
if [ $? -eq 0 ]; then
    echo "delete back directory ok!"
else
    echo -e "\033[31,47mdelete back directory failly\033[0m"
fi


# 包数据远程传输到另外一台服务器指定目录下
rsync -e ssh -a -z --compress-level=9 "${backDir}.tar.gz" 192.168.146.201:/mnt
if [ $? -eq 0 ]; then
    echo "rsync transfer ok!"
else
    echo -e "\033[31,47mrsync transfer failly\033[0m"
fi

rm -f "${backDir}.tar.gz"
