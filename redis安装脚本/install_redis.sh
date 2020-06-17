#!/bin/bash
#Author: liang jiang
#Date: 2018-03-15
# 修改redis.conf文件，确保ip为本机，以及123456的密码
# 该脚本执行完成后，检查redis是否配置OK
# cd /usr/local/bin
# redis-cli -h 配置的ip -p 6379 -a 配置的密码

cur_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
redis_file=redis-3.2.11.tar.gz
redis_dir=/usr/redis
redis_config_dir=/etc/redis

check_redis()
{
	#local_ip=$(ip a | grep -A 10 BROADCAST | grep -w inet | awk '{print $2}' | awk -F "/" '{print $1}' | head -n 1)
	redis_ping=$(redis-cli -h 127.0.0.1 -p 6379 -a 123456 <<-EOF
	ping
	EOF
	)
	if [ "x$redis_ping" == "xPONG" ];then return 0;fi
	return 27
}

if check_redis;then echo "[INFO]redis has been installed";exit 0;fi

yum -y install gcc

cd $cur_dir
mkdir -p $redis_dir
cp $cur_dir/$redis_file $redis_dir

cd $redis_dir
tar -zxvf $redis_file

cd ${redis_file%.tar.gz}
make && make install
mkdir -p $redis_config_dir

pwd
cd $cur_dir
cp redis.conf.template $redis_config_dir/redis.conf

# release redis.conf
# \rm -f redis.conf
mkdir -p /var/log/redis
cd /usr/local/bin/
./redis-server /etc/redis/redis.conf

if check_redis;then echo "[INFO]redis has been installed successfully";exit 0;fi
