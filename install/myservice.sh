#!/bin/bash

# service.start
function start()
{
    echo 'Service is startting'
    echo '...'
    sleep 1
    echo 'Service is started'
}
# service.stop
function stop()
{
    echo 'Service is stopping'
    echo '...'
    sleep 1
    echo 'Service is stopped'
}
# service.restart
function restart()
{
    stop
}
# service.other
function other()
{
    echo 'The supported arguments : start|stop|restart'
}

case $1 in
    start )
        start
        ;;
    stop )
        stop
        ;;
    restart )
        restart
        ;;
    * )
        other
        ;;
esac