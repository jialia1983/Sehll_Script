#!/bin/bash
#gent和service。反之则不作操作。
function get_pid_int
{
  echo $(echo `netstat -lntup | awk '/^tcp/{print $7}' | grep "$pid_name$"` | cut -d "/" -f 1)
}

pid_name="httpd"
Port="80"
restart_command="systemctl restart $pid_name"
http_code=`netstat -lntup | awk '/^tcp/{print $4}' | grep -q ":$Port$";echo $?`
pid_old=$(get_pid_int)


# 当httpd已经启动时，做重启操作
if [ $http_code -eq 0 ]
then
  echo "服务端口存在,重启$Service服务......"
  $restart_command  
  pid_new=$(get_pid_int)
  #echo $pid_new 
    if [ "x$pid_old" != "x$pid_new" ];then echo "重启服务$pid_name成功！";exit 0;
    else
    echo "重启服务$Serviice失败！"
	exit
	fi
fi

# 默认端口不存在，不执行
echo "服务端口不存在,不进行操作！"
