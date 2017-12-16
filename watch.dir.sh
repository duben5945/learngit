#!/bin/bash
#文件名watchdir.sh
#用途观察目录变化

path=$1

inotifywait -m -r -e create,move,delete $path -q
