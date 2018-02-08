#流程
BIGIN
Read a line
Execute AWK commands on a line 
Repeat 
END
#程序结构
BEGIN {awk-commands}
/pattern/ {awk-commands} #默认执行print
END {awk-commands}
#标准选项
-v #赋值
-F #指定分隔符
--dump-variables[=file] #输出全局变量到默认文件awkvars.out
--profile[=file] #输出格式化的程序到默认文件awkprof.out
#内建变量
ARGC #参数个数
ARGV #命令行参数数组
CONVFMT #数字的约定格式
ENVIRON #环境变量
FILENAME #当前文件名
FS #字段分隔符
OFS #字段输出分隔符
RS #记录分隔符 \n
ORS #输出记录分隔符
NF #字段数目
NR #行号
IGNORECASE #忽略大小写
$0 #当前行
$n #当前行第n个字段
~ ~! #使用正则匹配和非正则匹配
awk '{print $1,$2}' file
awk '{printf "%-8s %-10s\n" $1,$2}' file
awk '$1 ~ /pattern/ {print $1}'
BEGIN {语句}
END {语句}
表达式 {语句}
/正则表达式/ {语句}
组合模式 {语句} && || |
模式1,模式2 {语句}


