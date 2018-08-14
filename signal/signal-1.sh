#!/bin/bash
# singal testing
# 信号捕捉使用 trap 命令 ： trap "function" signal

# trap 'singalTest' 2 3
trap 'singalTest' 2 # 2=

function singalTest ()
{
    echo "正在按 ctrl+c; 系统无法终止"
}

i=0
while true; do
    let i++
    echo $i
    sleep 1
done