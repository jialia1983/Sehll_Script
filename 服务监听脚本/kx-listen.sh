#!/bin/bash
processpath=/srv/server/kxwz/
pid=$(ps x|grep kx-cms |grep -v grep|awk '{print $1}')
if [ -n "$pid" ];then
 kill -9 $pid
 cd $processpath
 ./start_cms.sh
 echo "`date` Detected NB-CMS Program running and restarting ! " | tee -a /var/log/kx-listen.log
else
 echo "`date` Detected NB-CMS program not running starting !" | tee -a /var/log/kx-listen.log
 cd $processpath
 ./start_cms.sh
fi
