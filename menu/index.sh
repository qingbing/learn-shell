#!/bin/bash
# This is a menu interface

# 1). view a user information
# 2). add a user
# 3). set password for user
# 4). delete a user
# 5). print disk space
# 6). print memory space
# 7). main menu
# 8). quit

. menu.sh

clear
menu

while true ; do
    read -p "Please input you option : " option
    case $option in
        1 )
            read -p "Please input a username : " username
            str=`id $username`
            echo -e "\033[30;47m${str}\033[0m"
            ;;
        2 )
            read -p "Creating user. Please input a username : " username
            useradd $username &> /dev/null
            if [ $? -eq 0 ]; then
                str="User ${username} created Successfully!"
                echo -e "\033[30;47m${str}\033[0m"
            else
                str="User ${username} created failly!"
                echo -e "\033[31;47m${str}\033[0m"
            fi
            ;;
        3 )
            read -p "Password for user. Please input a username : " username
            read -p "Set password for ${username} : " password
            echo $password | passwd --stdin $username &> /dev/null

            if [ $? -eq 0 ]; then
                str="Set password for ${username} Successfully!"
                echo -e "\033[30;47m${str}\033[0m"
            else
                str="Set password for ${username} failly!"
                echo -e "\033[31;47m${str}\033[0m"
            fi
            ;;
        4 )
            read -p "Delete user. Please input a username : " username
            userdel -r $username &> /dev/null
            if [ $? -eq 0 ]; then
                str="User ${username} delete Successfully!"
                echo -e "\033[30;47m${str}\033[0m"
            else
                str="User ${username} delete failly!"
                echo -e "\033[31;47m${str}\033[0m"
            fi
            ;;
        5 )
            str=`free -m`
            echo -e "\033[30;47m${str}\033[0m"
            ;;
        6 )
            str=`df -Th`
            echo -e "\033[30;47m${str}\033[0m"
            ;;
        7 )
            clear
            menu
            ;;
        8 )
            echo -e "\033[30;47mQuit!\033[0m"
            break
            ;;
        * )
            echo "The programer only support options : [1|2|3|4|5|6]"
            ;;
    esac
done