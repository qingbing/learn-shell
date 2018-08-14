#!/bin/bash
# singal testing
# 信号捕捉使用 trap 命令 ： trap "function" signal

trap 'singalTest' 2

function singalTest ()
{
    read -p "Are you sure you want to over it? yes or no : " input
    case $input in
        'yes' )
            exit;
            ;;
        'no' )
            ;;
        *)
            singalTest
            ;;
    esac
}

i=0
while true; do
    let i++
    echo $i
    sleep 1
done