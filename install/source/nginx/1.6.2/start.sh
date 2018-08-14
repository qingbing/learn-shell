#!/bin/bash
### START INIT INFO
# Short-Description: start|stop|status|restart|configtest
### END INIT INFO

# scripts PATH enviroment
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

# nginx general config
NAME="nginx"
BASEDIR=/usr/local/product/nginx
DAEMON="${BASEDIR}/sbin/nginx"
CONF="${BASEDIR}/conf/nginx.conf"
PIDFILE="${BASEDIR}/nginx.pid"
LOCKFILE="${BASEDIR}/nginx.lock"

# nginx start timeout milliscond
STARTTIME=10000
# nginx stop timeout milliscond
STOPTIME=10000

# common Function
color_msg(){
    local COLOR=$1
    local MSG=$2
    OFFSET="\033[60G"
    NORMAL="\033[0m"
    case $COLOR in
        red)
            COLOR="\033[1;40;31m"
            ;;
        green)
            COLOR="\033[1;40;32m"
            ;;
        yellow)
            COLOR="\033[1;40;33m"
            ;;
        *)
            COLOR="\033[0m"
            ;;
    esac
    echo -en "$OFFSET [$COLOR $MSG $NORMAL"
    echo     "]"
}

configtest() {
    echo -n "Configtest $NAME : "
    $DAEMON -tq -c $CONF
    if [ $? -eq 0 ] ;then
        color_msg green SUCCESS
    else
        color_msg red FAILED && exit 1
    fi
}

start() {
    echo -n "Starting $NAME : "
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -n "$PROC_PID" ]; then
        echo -n "is already running."
        color_msg yellow WARNING
    else
        $DAEMON -c $CONF >/dev/null 2>&1
        if [  $? -eq 0 ]; then
            color_msg green SUCCESS && touch $LOCKFILE
        else
            color_msg red FAILED && exit 1
        fi
    fi
}

stop() {
    echo -n "Stopping $NAME : "
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -z "$PROC_PID" ]; then
        echo -n "is not running."
        color_msg yellow WARNING
    else
        kill -TERM ${PROC_PID} >/dev/null 2>&1
        while [ "$STOPTIME" -gt 0 ]; do
            kill -0 ${PROC_PID} >/dev/null 2>&1 || break
            STOPTIME=$(($STOPTIME-1))
            echo -n "." && sleep 0.001s
        done
        if [ "$STOPTIME" -le 0 ]; then
            color_msg red TIMEOUT && exit 1
        else
            color_msg green SUCCESS
            rm -f $PIDFILE $LOCKFILE
        fi
    fi
}

restart() {
        echo -n "Restart $NAME : "
        echo
        echo -en "\t" && stop
        echo -en "\t" && start
}

reload() {
    echo -n "Reloading $NAME : "
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -n "$PROC_PID" ]; then
        kill -HUP ${PROC_PID} >/dev/null 2>&1
        if [  $? -eq 0 ]; then
            color_msg green SUCCESS
        else
            color_msg red FAILED && exit 1
        fi
    else
        echo -n "is not running."
        color_msg yellow WARNING
    fi
}

status() {
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -z "$PROC_PID" ];then
        echo "$NAME is stopped"
        exit 3
    else
        echo "$NAME (pid $PROC_PID) is running..."
        exit 0
    fi
}

quit() {
    echo -n "Quit $NAME : "
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -z "$PROC_PID" ]; then
        echo -n "is not running."
        color_msg yellow WARNING
    else
        kill -QUIT ${PROC_PID} >/dev/null 2>&1
        while [ "$STOPTIME" -gt 0 ]; do
            kill -0 ${PROC_PID} >/dev/null 2>&1 || break
            STOPTIME=$(($STOPTIME-1))
            echo -n "." && sleep 0.001s
        done
        if [ "$STOPTIME" -le 0 ]; then
            color_msg red TIMEOUT && exit 1
        else
            color_msg green SUCCESS
            rm -f $PIDFILE $LOCKFILE
        fi
    fi
}

logrotate() {
    echo -n "Re-opening $NAME log file : "
    PROC_PID=$(pgrep -P 1 -u root ^$NAME)
    if [ -z "$PROC_PID" ]; then
        echo -n "is not running."
        color_msg yellow WARNING
    else
        kill -USR1 ${PROC_PID} >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            color_msg green SUCCESS
        else
            color_msg red FAILED && exit 1
        fi
    fi
}

case "$1" in
    configtest)
        configtest
        ;;
    start)
        configtest
        start
        ;;
    stop)
        stop
        ;;
    restart|try-restart)
        configtest
        restart
        ;;
    reload|force-reload)
        configtest
        reload
        ;;
    status)
        status
        ;;
    quit)
        quit
        ;;
    logrotate)
        logrotate
        ;;
    *)
       echo $"Usage: $0 {configtest|start|stop|restart|reload|status|quit|logrotate}"
       exit 1
    ;;
esac