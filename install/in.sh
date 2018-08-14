#!/bin/bash
# install service, support service
#   mailx : need to config your owner mail in "./source/mailx/install.sh"

# get the realpath for this script file.
CURDIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

# include public lib file
. $CURDIR/lib/pub.sh

# get the service name which will be installed.
sname=$1

if [ -z $sname ]; then
    str="you must define the installing service name"
    echo -e "\033[31;47m${str}\033[0m"
else
    file=$CURDIR/source/$sname/"install.sh"
    # echo $file
    if [ -e $file ] && [ -f $file ]; then
        clear
        . $file # include file
        index # entrance
    else
        str="installing script for ${sname} is not found."
        echo -e "\033[31;47m${str}\033[0m"
    fi
fi
