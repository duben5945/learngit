#Stream Editor
#流程原理
Read——Execute——Display #默认输出pattern space空间内容
#模式空间(pattern space)和保持空间(hold space)
h pattern space > hold space copy
H pattern space >> hold space append
g pattern space < hold space copy
G pattern space << hold space append #hold space没有动作就加一个空行
x pattern space <<=>> hold space exchange
模仿tac的
sed '1!G;h;$!d' file
#基本命令
sed [option] 'sed-command' file
sed -f script-file file
#Option
-n silence
-e expression
-f file
-i edit files in place
-r regexp-extended 
-z separate lines by null characters
-l 行的长度
#循环
:label #定义标签
b 无条件跳转label 没有label就跳到结尾
t 有条件跳转 if语句
T 和t相反

#command
a append
i insert
c change
d delete
D 删除pattern space开端到\n内容,放弃之后的命令，对剩余pattern space重新
  执行sed-command
s replace s/old/new/g
y translate 单一字符一一映射
n Read the next line 提前读取下一行,sed命令只对新读取的行执行，如何n未执行成  功，则跳过后面命令
N append then next line 追加下一行到space,并看做有\n的一行,如何N未执行成功,
  则跳过后面命令;sed 不会无视每行末尾\n,但是会处理N命令追加的\n
p 打印pattern space
P 打印pattern space从开始到第一个\n
q quit
! 取反
= 打印行
& 存储搜索的内容
w write
l 输出隐藏字符 \t $
r 读取文件 r与文件 只有一个空格
e 执行外部命令
#元字符
^ 开始 $ 结尾 [] 字符集 [-] 字符范围  [^ ] 排除  \{n,m\} 重复字符  \(string \) \1 匹配字符串 
. 非换行任意字符  \? 0到1次  \+ 1次到多次 * 0次到多次 \< 单词开始  \> 单词结束 | 或操作 
\s 空白 \S 非空白 \w 单词 \W 非单词
#常用
, 范围 ;动作分隔
sed '/pattern/command' file
sed -n '1,$p' file

#
sed '/^$/d' #删除空行
sed '/./,/^$/!d' #删除连续空行
sed '/./,$!d' #删除开头的空行
sed ': start /^\n*$/{$d;N;b start}' #删除结尾空行
sed 's|#.*||g' #删除//注释
sed '1,10s/^/#/' #为某些行加入注释
sed -n '$=' #模拟wc -l 功能
sed '10q' #模拟head 功能
sed 's/^M$//' #模拟Dos2unix
sed 's/$/\$/' #模拟cat -E
sed -n 'l'|sed 'y/\\t/^I/' #模拟cat -ET
sed 'G' #插入空行
sed '/regex/{x;p;x;G} #行上下各加一空行
sed = file|sed 'N;s/\n/\t/' #给文件加上数字符号 模拟nl
sed -n 'w cp.txt' file #模拟cp
sed 's/\t/    /g' file #模拟expand
sed -n 'p;w tee.txt' file #模拟tee
sed -n '/regex/p' file #模拟grep
sed 'y/ABC/abc/' # 模拟tr
sed = file|sed '/./N;s/\n/ /' #给非空行打印数字
sed 's/^\s*//;s/\s*$//' #删除每行开头和结尾的空白
sed '1!G;h;$!d' #模拟tac
sed '/\n/G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//' #模拟rev
sed ':start;s/\B[0-9]\{3\}\b/,&/;t start' #给数字加, 可以看出单位如1234567变为1,234,567
sed '0~5G' #每5行加空格
sed ':a;$q;N;11,$D;ba' #模拟tail 11,$D 从第11行开始，每次都删除最上面的.*\n语句,保持模式空间只有10行
sed '/^.\{65\}/p' #输出大于65个字符的行
sed '/^.\{65\}/d' #输出小于65个字符的行
sed '53q;d' #输出53行 
sed 'N;P;D' #循环
sed ':a;$!N;/pattern/s/\n/ /;ta;P;D' #合并行
