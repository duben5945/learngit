#!/bin/bash
#文件名intruder_detect.sh
#用途 入侵报告，检测auth.log等日志
if [[ -n $1 ]];
then
	AUTHLOG=$1
	echo "Using Log file: $AUTHLOG"
fi

LOG=/tmp/valid.$$.log
grep -v "invalid" $AUTHLOG > $LOG
users=$(grep "Failed password" $LOG |awk '{ print $(NF-5) }'|sort|uniq)

printf "%-5s|%-10s|%-10s|%-13s|%-33s|%s\n" "Sr#" "User" "Attempts" "Ip address" "Host_Mapping" "Time range"

ucount=0

ip_list="$(grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" $LOG|sort |uniq)"

for ip in $ip_list;
do
	grep $ip $LOG >/tmp/temp.$$.log

	for user in $users;
	do
	grep $user /tem/temp.$$.log > /tmp/$$.log
	cut -c-16 /tmp/$$.log > $$.time
	tstart=$(head -1 $$.time);
	start=$(date -d "$tstart" "+%s");
	tend=$(tail -l $$.time);
	end=$(date -d "$tend" "+%s")

	limit=$(($end - $start))

		if [ $limit -gt 120 ];
		then
		let ucount++;
		IP=$(grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" /tmp/$$.log |head -n 1);		
		TIME_RANGE="$tstart-->$tend"

		ATTEMPTS=$(cat /tmp/$$.log|wc -l);

		HOST=$(host $IP | awk ' { print $NF }')

		printf "%-5s|%-10s|%-10s|%-10s|%-33s|%s\n" "$ucount" "$user" "$ATTEMPTS" "$IP" "$HOST" "$TIME_RANGE";
		fi
		done
   	done
