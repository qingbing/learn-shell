#!/bin/bash

# 键盘输入测试
echo -n "Please input your name : "
read name

# read -p "Please input your name : "name

echo -e "My name is \033[33;40m$name\033[0m"

# heredoc
cat<<X
list : 
    1、aaa
    2、bbb
    3、ccc
X