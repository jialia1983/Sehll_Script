#!/bin/bash
#通过检测服务端口判断进程是否启动。如果启动则重新启动Agent和service。反之则不作操作。
function pid_int
{
  pid_str=`netstat -lntup | awk '/^tcp/{print $7}' | grep "httpd$"`
  pid_number=`echo $pid_str | cut -d \/ -f 1`
  echo $pid_number
}

Port="80"
Service="httpd"
Restart="systemctl restart $Service"
count=`netstat -lntup | awk '/^tcp/{print $4}' | grep -q ":$Port$";echo $?`
pid_old=$(pid_int)
#echo $(pid_int)
if [ $count -eq 0 ]

then
  
  echo "服务端口存在,重启$Service 服务......"
  eval $Restart  
  pid_new=$(pid_int)
  #echo $pid_new 
    if [ "$pid_old" != "$pid_new" ]
    then 
       echo "重启服务$Service 成功！"
    else
      echo "重启服务$Service 失败！"
     fi
else
    echo "服务端口不存在,不进行操作！"
fi
