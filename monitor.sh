#/bin/bash
while getopts ivh name #三个参数，安装，版本，帮助
do
	case $name in
	i)
		iopt=1;;
	v)
		vopt=1;;
	h)
		hopt=1;;
	*)
		echo "Invalid arg";;
	esac
done

if [[ -n $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
#basename 去除前缀 readlink 找出实际文件
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
#scriptname为安装地址
su -c "cp $scriptname /usr/bin/monitor " root && echo "Congratulations! Script Installed,now run monitor Commond" || echo "Installation failed"
}
fi

if [[ -n $vopt ]]
then
{
echo -e "tecmint_monitor version 0.1\nDesigned by Tecmint.com\nReleased Under Apache 2.0 license"
}
fi

if [[ -n $hopt ]]
then
{
echo -e "-i	Install script"
echo -e "-v	Print version information and exit"
echo -e "-h	Print help (this information) and exit"
}
fi

if [[ $# -eq 0 ]]
then
{
clear

unset tecreset os architecture kernelrelease internalip externalop nameserver loadaverage

#Define Variable tecreset

tecreset=$(tput sgr0)

ping -c 1 www.baidu.com &> /dev/null && echo -e '\E[32m'"Internet:$tecreset Connected" || echo -e '\E[32m'"Internet: $tecreset Disconnected"

OS=$(uname -s)
REV=$(uname -r)
MACH=$(uname -m)

GetVersionFromFile()
{
	VERSION=$(cat $1 |tr "\n" ' ' | sed s/.*VERSION.*=\ //)
}

if [ "${OS}" = "SunOS" ];then
	OS=Solaris
	ARCH=$(uname -p)
	OSSTR="${OS} ${REV}(${ARCH} $(uname -v)"
elif [ "${OS}" = "AIX" ];then
	OSSTR="${OS} $(oslevel) ($(oslevel -r))"
elif [ "${OS}" = "Linux" ];then
	KERNEL=$(uname -r)
	if [ -f /etc/redhat-release ];then
		DIST='RedHat'
		PSUEDONAME=$(cat /etc/redhat-release |sed s/.*\(// |sed s/\(//)
		REV=$(cat /etc/redhat-release |sed s/.*release\ // |sed s/\ .*//)
	elif [ -f /etc/SuSE-release ];then
		DIST=$(cat /etc/SuSE-release |tr "\n" ' '|sed s/VERSION.*//)
		REV=$(cat /etc/Suse-release |tr "\n" ' '|sed s/.*=\ //)
	elif [ -f /etc/mandrake-release ];then
		DIST="Mandrake"
		PSUEDONAME=$(cat /etc/mandrake-release |sed s/.*\(// |sed s/\)//)
		REV=$(cat /etc/mandrake-release |sed s/.*release\ //| sed s/\ .*//)
	elif [ -f /etc/debian_version ];then
		DIST="Debian $(cat /etc/debian_version)"
		REV=""
	
	fi
	if ${OSSTR} [ -f /etc/UnitedLinux-release ];then
		DIST="${DIST}[$(cat /etc/UnitedLinux-release |tr "\n" ' ' |sed s/VERSION.*//)]"
	fi

	OSSTR="${OS} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"
fi


echo -e '\E[32m'"OS version :" $tecreset $OSSTR

architecture=$(uname -m)
echo -e '\E[32m'"Architecture :" $tecreset $architecture


kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernelrelease :" $tecreset $kernelrelease

echo -e '\E[32m'"Hostname :" $tecreset $HOSTNAME

internalip=$(hostname -I)
echo -e '\E[32m'"Internal IP :" $tecreset $internalip

externalip=$(curl -s ipecho,net/plain;echo)
echo -e '\E[32m'"Enternalip IP:" $tecreset $externalip

nameservers=$(cat /etc/resolv.conf |sed '1 d' |awk '{print $2}')
echo -e '\E[32m'"Name Servers:" $tecreset $nameservers

who>/tmp/who
echo -e '\E[32m'"Logged In users:" $tecreset && cat /tmp/who

free -h |grep -v + >/tmp/ramcache
echo -e '\E[32m'"Ram Usages:" $tecreset
cat /tmp/ramcache |grep -v "Swap"
echo -e '\E[32m'"Swap Usages :" $tecreset
cat /tmp/ramcache |grep -v "Mem"

df -h |grep 'Filesystem\|/dev/sda*' > /tmp/diskusage
echo -e '\E[32m'"Disk Usages :" $tecreset
cat /tmp/diskusage

loadaverage=$(top -n 1 -b |grep "load average :"|awk '{print $10 $11 $12}')
echo -e '\E[32m'"Load Average :" $tecreset $loadaverage

tecuptime=$(uptime |awk '{print $3,$4}'|cut -f1 -d,)
echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tecreset $tecuptime

unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

rm /tmp/who /tmp/ramcache /tmp/diskusage
}
fi

shift $(($OPTIND -1))
