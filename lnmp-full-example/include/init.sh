#!/bin/bash

Set_Timezone()
{
	Echo_Blue "Setting timezone..."
	rm -rf /etc/localtime
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

CentOS_InstallNTP()
{
	Echo_Blue "[+] Installing ntp..."
	yum install -y ntp
	ntpdate -u pool.ntp.org
	date
	start_time = $(date +%s)
}

Deb_InstallNTP()
{
	apt-get update-y
	Echo_Blue "[+] Installing ntp..."
	apt-get install -y ntpdate
	ntpdate -u pool.ntp.org
	date
	start_time = $(date +%s)
}

CentOS_RemoveAMP()
{
	Echo_Blue "[-] Yum remove packages..."
	rpm -qa | grep httpd
	rpm -e httpd httpd-tools --nodeps
	rpm -qa | grep mysql
	rpm -e mysql mysql-libs --nodeps
	rpm -qa | grep php
	rpm -e php-mysql php-cli php-gd php-common php --nodeps

	Remove_Error_Libcurl

	yum -y remove httpd*
	yum -y remove mysql-server mysql mysql-libs
	yum -y remove php*
	yum clear all
}

Deb_RemoveAMP()
{
	Echo_Blue "[-] apt-get remove packages..."
	apt-get update -y
	for removepackages in apache2 apache2-doc apache2-utils apache2.2-common apache2.2-bin apache2-mpm-prefork apach2-doc apache2-mpm-worker mysql-client mysql-server mysql-common mysql-server-core-5.5 mysql-client-5.5 php5 php5-common php5-cgi php5-cgi php5-mysql php5-curl php5-gd;
	do apt-get purge -y $removepackages; done
	killall apache2
	dpkg -l | grep apache2
	dpkg -P apache2 apache2-doc apache2-mpm-prefork apache2-utils apache2.2-common
	dpkg -l | grep mysql
	dpkg -P mysql-server mysql-common libmysqlclient15off libmysqlclient15-dev
	dpkg -l | grep php
	dpkg -P php5 php5-common php5-cli php5-cgi php5-mysql php5-curl php5-gd
	apt-get autoremove -y && apt-get clean
}

Disable_Selinux()
{
	if [-s /etc/selinux/config]; then
		sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
	fi
}

Xen_Hwcap_Setting()
{
	if [-s /etc/ld.so.conf.d/libc6-xen.conf]; then
		sed -i 's/hwcap 1 nosegneg/hwcap 0 nesegneg/g' /etc/ld.so.conf.d/libc6-xen.conf
	fi	
}

Check_Hosts()
{
	if grep -Eqi '^127.0.0.1[[:space:]]*localhost' /etc/hosts; then
		echo "Hosts: ok."
	else
		echo "127.0.0.1 localhost.localdomain localhost"	
}