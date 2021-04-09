## 记录日志
echo "---------------------------------------------------" >> /serverBack/dbBack/dbBackLog.log
echo $(date +"%Y-%m-%d %H:%M:%S") "test Database backup start"  >> /serverBack/dbBack/dbBackLog.log
## 开始备份
mysqldump -uroot -ppwd test >> /serverBack/dbBack/test_$(date +"%Y-%m-%d").sql
## $? 判断上一次操作是否成功，备份成功返回0
if [ 0 -eq $? ];then

    if [ -f "/serverBack/dbBack/test_$(date +"%Y-%m-%d").sql" ];then
        echo $(date +"%Y-%m-%d %H:%M:%S") "test Database backup success!" >> /serverBack/dbBack/dbBackLog.log
    else
        echo $(date +"%Y-%m-%d %H:%M:%S") "test Database backup fail!" >> /serverBack/dbBack/dbBackLog.log
    fi

else
    echo $(date +"%Y-%m-%d %H:%M:%S") "test Database backup error!" >> /serverBack/dbBack/dbBackLog.log

fi

echo "---------------------------------------------------" >> /serverBack/dbBack/dbBackLog.log
## 删除七天前的数据，防止数据冗余
find /serverBack/dbBack/ -mtime +7 -name "test_*.sql" -exec rm -rf {} \;
