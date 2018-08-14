#!/bin/bash
# install mailx

# yum -y install mailx
# yum -y remove mailx

CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

LOGDIR=$CURDIR/log
addDir $LOGDIR

LOGFILE=$LOGDIR/install.log
date '+%Y-%m-%d %T - mailx install'> $LOGFILE
echo '==========================================='>> $LOGFILE

sname='mailx'

form='xxx@163.com'
smtp='smtp.163.com'
smtpAuthUser='xxx@163.com'
smtpAuthPassword='xxx'
testMail='xxx@qq.com'

smtpAuth='login'


# install service
function install ()
{
    echo " ********** ${sname} install ********** " | tee -a $LOGFILE

    yum -y install ${sname} | tee -a $LOGFILE

    if [ $? -eq 0 ]; then
        str="${sname} install sucessfully!"
        echo -e "\033[30;47m${str}\033[0m"
    else
        str="${sname} install failly!"
        echo -e "\033[31;47m${str}\033[0m"
    fi
}
# uninstall service
function uninstall ()
{
    echo " ********** ${sname} uninstall ********** " | tee -a $LOGFILE

    yum -y remove ${sname} | tee -a $LOGFILE

    if [ $? -eq 0 ]; then
        str="${sname} uninstall sucessfully!"
        echo -e "\033[30;47m${str}\033[0m"
    else
        str="${sname} uninstall failly!"
        echo -e "\033[31;47m${str}\033[0m"
    fi
}

function config ()
{
    echo " ********** ${sname} config ********** " | tee -a $LOGFILE

    cp /etc/mail.rc /etc/mail.rc.bak

    echo "set from=${form}" >> /etc/mail.rc
    echo "set smtp=${smtp}" >> /etc/mail.rc
    echo "set smtp-auth-user=${smtpAuthUser}" >> /etc/mail.rc
    echo "set smtp-auth-password=${smtpAuthPassword}" >> /etc/mail.rc
    echo "set smtp-auth=${smtpAuth}" >> /etc/mail.rc
    
    str="${sname} config success!"
    echo -e "\033[30;47m${str}\033[0m" | tee -a $LOGFILE
}

function testing ()
{
    echo "`date`\nHello Tesing" | mail -s "Testing" "${testMail}" | tee -a $LOGFILE


    if [ $? -eq 0 ]; then
        str="send mail sucessfully!"
        echo -e "\033[30;47m${str}\033[0m" | tee -a $LOGFILE
    else
        str="send mail failly!"
        echo -e "\033[31;47m${str}\033[0m" | tee -a $LOGFILE
    fi
}

# entrance
function index ()
{
    # whether is exist.
    rpm -qa | grep ${sname}


    if [ $? eq 0 ]; then
        uninstall
        install
        config
        testing
    else
        read -p "${sname} has been installed on this machine. whether to force installation? yes/no : " input

        if [ $input = 'y' ] || [ $input = 'yes' ]; then
                uninstall
                install
                config
                testing
        fi
    fi
}