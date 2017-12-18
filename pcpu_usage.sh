#!/bin/bash
#文件名 pcpu_usage.sh
#用途 计算进程的CPU占用时间

SECS=360
UNIT_TIME=60

STEPS=$(( $SECS/$UNIT_TIME ))

echo "Watching CPU usage...";

for((i=0;i<$STEPS;i++))
do
	ps -eo comm,pcpu|tail -n +2 >> /tmp/cpu_usage.$$
	sleep $UNIT_TIME
done

echo -e "\nCPU eaters:"
cat /tmp/cpu_usage.$$ |\
awk '{ process[$1]+=$2;}
END{for(i in process)
{
	printf("%-20s %s\n",i,process[i]);
}
   }'|sort -nrk 2|head

rm /tmp/cpu_usage.$$


