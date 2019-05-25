#!/bin/bash

# docker批量 start|stop|restart|status 其中的应用

function start_docker_internal_app()
{
	docker_name = $1
	app_name = $2
	app_ops_operation = $3
	abc = $(docker exec -it $docker_name su -work -c "/home/user/app/$app_name/bin/console $app_ops_operation")
}

function get_docker_app_name()
{
	ops_oper = $1
	for i in `docker ps -a|awk '{if ($8 == "Up") print $NF}' | grep -v "CONTAINER" | grep -v "^$"`
	do
		result = $(docker exec -it $i ls -lrt /home/user/app/ | tail -1 | awk '{print $9}' | tr -d "\r")
		start_docker_internal_app $i $result $ops_oper
	done
}

case "$1" in
	start)
		echo -e "\033[32m 应用启动 \033[0m"
		ops_operation = 'start'
		get_docker_app_name $ops_operation
		$1
		;;
	stop)
		echo -e "\033[32m 应用停止 \033[0m"
		ops_operation = 'stop'
		get_docker_app_name $ops_operation
		$1
		;;
	restart)
		echo -e "\033[32m 应用重启 \033[0m"
		ops_operation = 'restart'
		get_docker_app_name $ops_operation
		$1
		;;
	status)
		echo -e "\033[32m 检查程序 \033[0m"
		ops_operation = 'status'
		get_docker_app_name $ops_operation
		;;
	*)
	echo -e '\033[31m Docker内部应用管理，请输入 "$"Usage: $0 {status|start|stop|restart}" \033[0m'
	exit 2
esac
