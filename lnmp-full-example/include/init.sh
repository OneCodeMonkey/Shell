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
		echo "127.0.0.1 localhost.localdomain localhost" >> /etc/hosts
	fi
	pingresult = `ping -c1 lnmp.org 2>&1`
	echo "${pingresult}"
	if echo "${pingresult}" | grep -q "unknown host"; then
		echo "DNS fail"
		echo "Writing nameserver to /etc/resolv.conf..."
		echo -e "nameserver 208.67.220.220\nnameserver 114.114.114.114" > /etc/resolv.conf
	else
		echo "Dns...ok"
	fi	
}

RHEL_Modify_Source()
{
	GET_RHEL_Version
	\cp $(cur_dir)/conf/CentOS-Base-163.repo /etc/yum.repos.d/CentOS-Base-163.repo
	sed -i "s/RPM-GPG-KEY-CentOS-6/RPM-GPG-KEY-CentOS-${RHEL_Ver}/g" /etc/yum.repos.d/CentOS-Base-163.repo
	yum clean all
	yum makecache
}

Ubuntu_Modify_Source()
{
	if ["${country}" = "CN"]; then
		OldReleasesURL = 'http://mirrors.ustc.edu.cn/ubuntu-old-releases/ubuntu/'
	else
		OldReleasesURL = 'http://old-releases.ubuntu.com/ubuntu/'
	fi
	CodeName = ''
	if grep -Eqi "10.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^10.10'; then
        CodeName='maverick'
    elif grep -Eqi "11.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^11.04'; then
        CodeName='natty'
    elif  grep -Eqi "11.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^11.10'; then
        CodeName='oneiric'
    elif grep -Eqi "12.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^12.10'; then
        CodeName='quantal'
    elif grep -Eqi "13.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^13.04'; then
        CodeName='raring'
    elif grep -Eqi "13.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^13.10'; then
        CodeName='saucy'
    elif grep -Eqi "10.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^10.04'; then
        CodeName='lucid'
    elif grep -Eqi "14.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^14.10'; then
        CodeName='utopic'
    elif grep -Eqi "15.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^15.04'; then
        CodeName='vivid'
    elif grep -Eqi "12.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^12.04'; then
        CodeName='precise'
    elif grep -Eqi "15.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^15.10'; then
        CodeName='wily'
    elif grep -Eqi "16.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^16.10'; then
        CodeName='yakkety'
    elif grep -Eqi "14.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^14.04'; then
        Ubuntu_Deadline trusty
    elif grep -Eqi "17.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^17.04'; then
        CodeName='zesty'
    elif grep -Eqi "17.10" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^17.10'; then
        Ubuntu_Deadline artful
    elif grep -Eqi "16.04" /etc/*-release || echo "${Ubuntu_Version}" | grep -Eqi '^16.04'; then
        Ubuntu_Deadline xenial
    fi
    if [ "${CodeName}" != "" ]; then
        \cp /etc/apt/sources.list /etc/apt/sources.list.$(date +"%Y%m%d")
        cat > /etc/apt/sources.list<<EOF
deb ${OldReleasesURL} ${CodeName} main restricted universe multiverse
deb ${OldReleasesURL} ${CodeName}-security main restricted universe multiverse
deb ${OldReleasesURL} ${CodeName}-updates main restricted universe multiverse
deb ${OldReleasesURL} ${CodeName}-proposed main restricted universe multiverse
deb ${OldReleasesURL} ${CodeName}-backports main restricted universe multiverse
deb-src ${OldReleasesURL} ${CodeName} main restricted universe multiverse
deb-src ${OldReleasesURL} ${CodeName}-security main restricted universe multiverse
deb-src ${OldReleasesURL} ${CodeName}-updates main restricted universe multiverse
deb-src ${OldReleasesURL} ${CodeName}-proposed main restricted universe multiverse
deb-src ${OldReleasesURL} ${CodeName}-backports main restricted universe multiverse
EOF
    fi
}

Check_Old_Releases_URL()
{
	OR_Status = `wget --spider --server-response ${OldReleasesURL}/dists/$1/Release 2>&1 | awk '/^HTTP/{print $2}'`
	if [ ${OR_Status} != '404']; then
		echo "Ubuntu old-releases status: ${OR_Status}";
		codeName = $1
	fi
}

Ubuntu_Deadline()
{
	trusty_deadline = `date-d "2019-7-22 00:00:00" +%s`
	artful_deadline = `date-d "2018-7-31 00:00:00" +%s`
	xenial_deadline = `date-d "2021-4-30 00:00:00" +%s`
	cur_time = `date +%s`
	case "$1" in
		trusty)
			if [ ${cur_time} -gt ${trusty_deadline} ]; then
				echo "${cur_time} > ${trusty_deadline}"
				Check_Old_Releases_URL trusty
			fi
			;;
		artful)
			if [ ${cur_time} -gt ${artful_deadline} ]; then
				echo "${cur_time} > ${artful_deadline}"
				Check_Old_Releases_URL artful
			fi
			;;
		xenial)
			if [ ${cur_time} -gt ${xenial_deadline} ]; then
				echo "${cur_time} > ${xenial_deadline}"
				Check_Old_Releases_URL xenial
			fi
			;;
	esac		
}