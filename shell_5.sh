#!/bin/bash

# 条件测试中，返回0表示成功，非0表示失败
if [ -e file1.txt ]; then
	echo "file1.txt is exist"
else
	date > file1.txt
	echo "file1.txt is not exist"
fi

if [[ -d /etc ]]; then
	echo "/etc 是目录"
fi

if [[ -e /etc/profile ]]; then
	echo "/etc/profile 文件存在"
fi

age=20
if [ $age -gt 18 ] && [ $age -lt 24 ]; then
	echo '豆蔻年华'
fi

score=80
if [ $score -lt 60 ]; then
	echo "x < 60"
elif [ $score -lt 80 ]; then
	echo "60<= x < 80"
elif [ $score -lt 90 ]; then
	echo "80<= x < 90"
else
	echo "x >= 90"
fi

# 获取当天的星期
week=`date +%w`
case $week in
	1 )
	echo "周一"
		;;
	2 )
	echo "周二"
		;;
	3 )
	echo "周三"
		;;
	4 )
	echo "周四"
		;;
	5)
	echo "周五"
		;;
	6 )
	echo "周六"
		;;
	0 )
	echo "周日"
		;;
esac

case $1 in
	start )
		echo "start !!"
		;;
	stop )
		echo "stop !!"
		;;
	restart )
		echo "restart !!"
		;;
	* )
		echo "You can input : start|stop|restart"
		;;
esac

# 循环求和
num=3
sum=0
while [ $num -gt 0 ]; do
	sum=$(($num+$sum))
	num=$(($num-1))
done
echo $sum;


# 颜色隔行显示
i=0
while [ $i -lt 10 ]; do
	if [ $(($i%2)) -eq 0 ]; then
		echo $i
	else
		# echo -e "\033[30;47m$i\033[0m" # 或
		echo -e "\033[30;47m${i}\033[0m"
	fi
	i=$(($i+1))
done


for userinfo in `cat /etc/passwd | awk -F: '{print $1}'`; do
	echo $userinfo
done

tot=1
while [ $# -gt 0 ]; do
	tot=$(($tot+$1))
	shift
done
echo $tot


function add()
{
	# tot=`expr $1 + $2`
	tot=$(($1+$2))
	# num=$1;
	# tot=0
	# for (( i = 0; i < $num; i++ )); do
	# 	tot=$(($tot+$i))
	# done
	echo $tot
}

add 1 99

