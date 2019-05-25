#!/bin/bash
# under centos7.5

slave_user = 'slave1'
slave_password = '123456'
slave_ipaddr = '192.168.1.102'
master_ipaddr = '192.168.1.104'
yum -y install openssh-clients
yum -y install mysql mysql-server mysql-devel
sed -i '/^\[mysqld\]$/a\server-id=1' /etc/my.cnf
sed -i '/^\[mysqld\]$/a\log-bin=mysql-bin' /etc/my.cnf

/etc/init.d/mysqld restart

# set mysql password
mysqladmin -u root password '123456'
mysql -uroot -p123456 -e "grant replication slave, super, reload on *.* to '$slave_user'@'$slave_ipaddr' identified by '$slave_password';"

master_status = `mysql -uroot -p123456 -e "show mastaer status;"`
echo "$master_status"
binlogname = `echo "$master_status" | grep bin | awk '{print $1}'`
echo '$binlogname'
position = `echo "$master_status" | grep bin | awk '{print $2}'`
echo '$position'

# set slave
ssh root@$slave_ipaddr > /dev/null 2>&1 << eeooff
yum -y install mysql mysql-server mysql-devel
sed -i '/^\[mysqld\]$/a\server-id=2' /etc/my.cnf
/etc/init.d/mysqld restart
mysqladmin -u root password '123456'
mysql -uroot -p123456 -e 'stop slave;'
mysql -uroot -p123456 -e "change master to master_host = '$master_ipaddr', master_user = '$slave_user', master_password='$slave_password', master_log_file = '$binlogname', master_log_pos = '$position';"
mysql -uroot -p123456 -e 'start slave;'

# 判断slave
slave_status = mysql -uroot -p123456 -e "show slave status\G;" | grep yes | wc -l
if [$slave_status == 2] then
	echo "slave is ok."
else
	echo "slave fail."
fi
exit
eeooff		