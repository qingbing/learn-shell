#!/bin/bash

function addDir ()
{
    dir=$1
    if [ ! -e $dir ] || [ ! -d $dir ] ; then
        mkdir -p $dir;
    fi
}


# firewall-cmd --zone=public --query-port=80/tcp
# firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --zone=public --remove-port=80/tcp --permanent
# firewall-cmd --reload
# firewall-cmd --zone=public --list-ports
# $1 : 80/tcp
function addFirewallPort ()
{
    # view the firewall port
    firewall-cmd --zone=public --query-port=$1 &> /dev/null
    if [ $? -ne 0 ]; then
        firewall-cmd --zone=public --add-port=$1 --permanent
        if [ $? -ne 0 ]; then
            echo "firewall port add fail."
        fi
    fi
}

function reloadFirewall ()
{
    firewall-cmd --reload
}