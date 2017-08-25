#!/bin/bash -vx
#Name:restart.sh
#Version:1.0
#Date:2017-8-24
#Author:jiangliang
function get_pid_int
{
  echo $(echo `netstat -lntup | awk '/^tcp/{print $7}' | grep "$pid_name$"` | cut -d "/" -f 1)
}

#exec > /home/restart.log
sleep_number="10s"
pid_name="httpd"
Port="80"
restart_command="systemctl restart $pid_name"
http_code=`netstat -lntup | awk '/^tcp/{print $4}' | grep -q ":$Port$";echo $?`
pid_old=$(get_pid_int)
#echo $pid_old
# 当服务已经启动时，做重启操作
if [ $http_code -eq 0 ]
then
  	echo "$pid_name 重新启动中......"
  	$restart_command
  	if [ $http_code != 0 ]
	then
		for (( i=1; i<= 3; i++))
		do
		 sleep $sleep_number
		 if [ $http_code -eq 0 ]
		 then
			exit 0;
		fi
		done
	fi
		 pid_new=$(get_pid_int)	
  	#echo $pid_new 
    	if [ $http_code -eq 0 ]  && [ "x$pid_old" != "x$pid_new" ];then echo "重启 $pid_name 成功！";exit 0;
    	else
    	echo "重启 $pid_name 失败！"
		exit
		fi
fi
# 当服务没有启动则不进行操作！
echo "服务不存在！"
