#!/bin/bash
#This shell script will create amount of linux login accounts for you.
#1.Check the "acountadd.txt" file exist? you must create that file manually.
#one account name one line in the "accountadd.txt" file.
#2.Use openssl to create users password
#3.User must change his password in his first login.
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

#userinput
usergroup="" #if your account need secondary group,add here.
pwmech="openssl" #"openssl" or "account" is needed.
homeperm="no" #if "yes" then I will modify home dir permission to 711

#Check the acountadd.txt
#"create" is useradd and "delete" is userdel.
action="${1}"
if [ ! -f accountadd.txt ];then
	echo "There is no accountadd.txt file,stop here."
	exit 1
fi

[ "${usergroup}" != "" ] && groupadd -r ${usergroup}
rm -f outputpw.txt
usernames=$(cat accountadd.txt)

for username in ${usernames}
do
	case ${action} in
	"create")
	[ "${usergroup}" != "" ] && usegrp="-G ${usergroup}" ||usegrp=""
	useradd ${usegrp} ${username}
	[ "${pwmech}" == "openssl" ] && usepw=$(openssl rand -base64 6)||usepw="${username}"
	echo "${username}:${usepw}" |chpasswd
	chage -d 0 ${username}
	[ "${homeperm}" == "yes" ] && chmod 711 /home/${username}
	echo "username=${username},password=${usepw}" >>outputpw.txt;;
	"delete")
	echo "deleting ${username}"
	userdel -r ${username};;
	*)
	echo "Usage:$0 [create|delete]";;
	esac 
done
