#!/bin/bash
 function Get_Dist_Name()
{
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO
}

dist_name=$(Get_Dist_Name)
if [ "$dist_name" != "CentOS" -a "$dist_name" != "Debian" -a "$dist_name" != "Ubuntu" ] ; then
    echo "当前脚本只支持Centos或者Debian/Ubuntu系统！"
    exit
fi

if ! test -e ~/.ssh
then
    mkdir ~/.ssh
fi 

read  -p "请输入公钥(id_rsa.pub)的web下载地址：" url
if [ -z "${url}" ];then
	url="https://raw.githubusercontent.com/ZavierXing/script/master/ssh_by_key/id_ecdsa.pub"
fi

wget -c ${url} -O ~/.ssh/authorized_keys

if [! test -s  ~/.ssh/authorized_keys];then
    echo "私钥文件内容空"
    exit
fi

chmod 644 ~/.ssh/authorized_keys
mv /etc/ssh/sshd_config /etc/ssh/sshd_config_back
wget https://raw.githubusercontent.com/ZavierXing/script/master/ssh_by_key/sshd_config -O /etc/ssh/sshd_config

systemctl restart sshd.service
