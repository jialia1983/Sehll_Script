#!/bin/bash
#通过检测服务端口判断进程是否启动。如果启动则重新启动Agent和service。反之则不作操作。
Port="80"
Service="httpd"
Restart="systemctl restart $Service"
count=`netstat -lntup | awk '/^tcp/{print $4}' | grep -q ":$Port$";echo $?`
count_old_str=`netstat -lntup | awk '/^tcp/{print $7}' | grep "$Service$"`
pid_old=`echo $count_old_str | cut -d \/ -f 1`
#echo $pid_old
if [ $count -eq 0 ]

then
  
  echo "服务端口存在,重启$Service 服务......"
  eval $Restart  
  count_new_str=`netstat -lntup | awk '/^tcp/{print $7}' | grep "$Service$"`
  pid_new=`echo $count_new_str | cut -d \/ -f 1`
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
