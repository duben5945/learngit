#!/bin/bash
#文件：ping.sh
#用途 检查IP地址是否活动
for ip in 192.168.11.$(seq 1 250);
do
	ping  $ip -c 1 & >/dev/null ;
	if [ $? -eq 0 ];
	then
		echo -e "$ip is alive\n" >/home/duben/ping.txt;
	fi
done
