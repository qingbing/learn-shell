#!/bin/bash
# singal testing
# 信号捕捉使用 trap 命令 ： trap "function" signal

trap 'singalTest' 2
trap 'singalTest1' 3

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

function singalTest1 ()
{
    echo "I recive a 3 singal."
}

i=0
while true; do
    let i++
    echo $i
    sleep 1
done