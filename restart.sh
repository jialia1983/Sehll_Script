#!/bin/bash -xv
#Name:restart.sh
#Version:1.0
#Date:2017-8-24
#Author:jiangliang
function get_pid_int
{
  echo `netstat -lntp | awk '{print $0, $4}' | grep :7180$ | awk '{print $7}' | awk -F '/' '{print $1}'`
}

sleep_number="30s"
pid_name="cloudera-scm-server"
Port="7180"
#pid_name="httpd"
#Port="80"
restart_command="systemctl restart $pid_name"
http_code_cmd=`netstat -lntp | awk '/^tcp/{print $4}' | grep -q ":$Port$";echo $?`
string_http="echo \"netstat -lntp | awk '/^tcp/{print \$4}' | grep  -q \":$Port$\"\" | /bin/bash;echo \$?"
pid_old=$(get_pid_int)
# 当服务已经启动时，做重启操作
if [ $http_code_cmd -eq 0 ]
then
  echo "$pid_name 重新启动中......"
  $restart_command
  sleep 2
    if [ `eval $string_http` -ne  0 ]
    then
    for (( i=1; i<= 30; i++ ))
    do
    sleep $sleep_number
      if [ `eval $string_http` -eq 0 ]
      then
          break; 
      fi
     done
     fi
pid_new=$(get_pid_int)	 
if [ `eval $string_http` -eq 0 ]  && [ x"$pid_old" != x"$pid_new" ];then echo "重启 $pid_name 成功！";exit 0;
else
echo "重启 $pid_name 失败！因为新端口号 $pid_new 和就端口号 $pid_old 一致！"
exit
fi
fi
# 当服务没有启动则不进行操作！
echo "服务不存在！"
