#!/bin/bash
processpath=/srv/server/nbwz/
pid=$(ps x|grep nb-cms |grep -v grep|awk '{print $1}')
if [ -n "$pid" ];then
 kill -9 $pid
 cd $processpath
 ./start_cms.sh
 echo "`date` Detected NB-CMS Program running and restarting ! " | tee -a /var/log/nb-listen.log
else
 echo "`date` Detected NB-CMS program not running starting !" | tee -a /var/log/nb-listen.log
 cd $processpath
 ./start_cms.sh
fi
