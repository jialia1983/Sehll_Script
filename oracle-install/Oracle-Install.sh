#!/bin/bash
# Author: jiang liang
# Date: 2018-08-09
# Install steps and remote call functions
# WARNING: PLEASE DO NOT MODIFY THIE FILE BY ATTENTION!

#安装Oracle前置依赖包
Install_Oracle_rely_on()
{
   yum -y install gcc gcc-c++ make binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static glibc glibc-common glibc-devel ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel numactl-devel sysstat unixODBC unixODBC-devel kernelheaders pdksh pcre-devel readline rlwrap unzip net-tools
}

#创建Oracle用户及组
Create_Oracle_user_group()
{
    groupadd oinstall && groupadd dba && useradd -g oinstall -G dba oracle
    echo "123456" | passwd --stdin oracle && id oracle　
}

#创建安装包文件存放目录
Create_Oracle_install_mkdir()
{	
    mkdir -p /data/u01/software
    cp linux.x64_11gR2_database_* /data/u01/software/ && cd /data/u01/software
}

#解压缩Oracle安装包
Unzip_Oracle()
{
    unzip linux.x64_11gR2_database_1of2.zip && unzip linux.x64_11gR2_database_2of2.zip
}

#创建Oracle目录
Create_Oracle_mkdir()
{
    mkdir -p /data/u01/app/oracle/product/11.2.0/dbhome_1
    mkdir /data/u01/app/oracle/{oradata,inventory,fast_recovery_area}
    chown -R oracle:oinstall /data/u01/app/oracle
    chmod -R 775 /data/u01/app/oracle
}

#修改/etc/sysctl.conf系统内核参数
Modify_the_kernel()
{
    echo "fs.aio-max-nr = 1048576" >> /etc/sysctl.conf
    echo "fs.file-max = 6815744" >> /etc/sysctl.conf
    echo "kernel.shmall = 2097152" >> /etc/sysctl.conf
    echo "kernel.shmmax = 1073741824" >> /etc/sysctl.conf
    echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
    echo "kernel.sem = 250 32000 100 128" >> /etc/sysctl.conf
    echo "net.ipv4.ip_local_port_range = 9000 65500" >> /etc/sysctl.conf
    echo "net.core.rmem_default = 262144" >> /etc/sysctl.conf
    echo "net.core.rmem_max = 4194304" >> /etc/sysctl.conf
    echo "net.core.wmem_default = 262144" >> /etc/sysctl.conf
    echo "net.core.wmem_max = 1048576" >> /etc/sysctl.conf
    sysctl -p
}

#修改/etc/security/limits.conf用户限制
Modify_the_user()
{
    echo "oracle soft nproc 2047" >> /etc/security/limits.conf
    echo "oracle hard nproc 16384" >> /etc/security/limits.conf
    echo "oracle soft nofile 1024" >> /etc/security/limits.conf
    echo "oracle hard nofile 65536" >> /etc/security/limits.conf
    echo "oracle soft stack 10240" >> /etc/security/limits.conf
}

#修改/etc/pam.d/login文件
Modify_pam_login()
{
    echo "# Oracle" >> /etc/pam.d/login
    echo "session    required     /lib64/security/pam_limits.so" >> /etc/pam.d/login
    echo "session    required     pam_limits.so" >> /etc/pam.d/login
}

#修改/etc/profile文件
Modify_root_profile()
{
    echo "if [ \$USER = \"oracle\" ]; then" >> /etc/profile
    echo "   if [ \$SHELL = \"/bin/ksh\" ]; then" >> /etc/profile
    echo "       ulimit -p 16384" >> /etc/profile
    echo "       ulimit -n 65536" >> /etc/profile
    echo "   else" >> /etc/profile
    echo "       ulimit -u 16384 -n 65536" >> /etc/profile
    echo "   fi" >> /etc/profile
    echo "fi" >> /etc/profile
    echo ""　
}

#设置Oracle用户环境变量
#echo "alias sqlplus='rlwrap sqlplus'" >> .bash_profile
#echo "alias rman='rlwrap rman'" >> .bash_profile
Modify_oracle_bash_profile()
{
    su - oracle <<EOF
    echo "export ORACLE_BASE=/data/u01/app/oracle" >> .bash_profile
    echo "export ORACLE_HOME=/data/u01/app/oracle/product/11.2.0/dbhome_1" >> .bash_profile
    echo "export ORACLE_SID=orcl" >> .bash_profile
    echo 'export ORACLE_UNQNAME=\$ORACLE_SID' >> .bash_profile
    echo 'export PATH=\$ORACLE_HOME/bin:\$PATH' >> .bash_profile
    echo "export NLS_LANG=american_america.AL32UTF8" >> .bash_profile
    source .bash_profile
    cat .bash_profile
    exit;
EOF
}

#编辑静默安装配置文件
#cp -R /data/u01/software/database/response/ . && cd response/
Modify_db_install_rsp()
{
    su - oracle <<EOF
    cp -R /data/u01/software/database/response/ . && cd response/
    sed -i 's/oracle.install.option=/oracle.install.option=INSTALL_DB_SWONLY/g' db_install.rsp
    sed -i 's/ORACLE_HOSTNAME=/ORACLE_HOSTNAME=$HOSTNAME/g' db_install.rsp
    sed -i 's/UNIX_GROUP_NAME=/UNIX_GROUP_NAME=oinstall/g' db_install.rsp
    sed -i 's/INVENTORY_LOCATION=/INVENTORY_LOCATION=\/data\/u01\/app\/oracle\/inventory/g' db_install.rsp
    sed -i 's/SELECTED_LANGUAGES=/SELECTED_LANGUAGES=en,zh_CN/g' db_install.rsp
    sed -i 's/ORACLE_HOME=/ORACLE_HOME=\/data\/u01\/app\/oracle\/product\/11.2.0\/dbhome_1/g' db_install.rsp
    sed -i 's/ORACLE_BASE=/ORACLE_BASE=\/data\/u01\/app\/oracle/g' db_install.rsp
    sed -i 's/oracle.install.db.InstallEdition=/oracle.install.db.InstallEdition=EE/g' db_install.rsp
    sed -i 's/oracle.install.db.DBA_GROUP=/oracle.install.db.DBA_GROUP=dba/g' db_install.rsp
    sed -i 's/oracle.install.db.OPER_GROUP=/oracle.install.db.OPER_GROUP=dba/g' db_install.rsp
    sed -i 's/DECLINE_SECURITY_UPDATES=/DECLINE_SECURITY_UPDATES=true/g' db_install.rsp
    exit;
EOF
}

#安装Oracle
Setup_Oracle()
{
    su - oracle <<EOF
    cd /data/u01/software/database/
    ./runInstaller -silent -responseFile /home/oracle/response/db_install.rsp -ignorePrereq
    exit;
EOF
}

#以root用户执行脚本
Modify_sh()
{
    #su - 
    #source ./home/oracle/bash_profle 
    sh /data/u01/app/oracle/inventory/orainstRoot.sh
    sh /data/u01/app/oracle/product/11.2.0/dbhome_1/root.sh
}

#查看监听响应配置文件
Modify_netca_rsp()
{
    egrep -v "(^#|^$)" /home/oracle/response/netca.rsp
    su - oracle <<EOF
    source .bash_profle
    netca /silent /responsefile /home/oracle/response/netca.rsp
    exit;
EOF
}

#用Oracle用户启动
Start_Oracle()
{
    su - oracle <<EOF
    lsnrctl start
    netstat -tunlp|grep 1521 
    lsnrctl status
    cat $ORACLE_HOME/network/admin/listener.ora
    cat $ORACLE_HOME/network/admin/tnsnames.ora
    exit;
EOF
}

#配置以静默方式建立新库,和实例的响应文件
Modify_dbca_rsp()
{
    su - oracle <<EOF
    cd /home/oracle/response/
    sed -ri 's/(GDBNAME = ")[^"]*/\GDBNAME = "orcl/g' dbca.rsp
    sed -ri 's/(SID = ")[^"]*/\SID = "orcl/g' dbca.rsp
    sed -ri 's/(#SYSPASSWORD = ")[^"]*/\SYSPASSWORD = "123456/g' dbca.rsp
    sed -ri 's/(#SYSTEMPASSWORD = ")[^"]*/\SYSTEMPASSWORD = "123456/g' dbca.rsp
    sed -ri 's/(#SYSMANPASSWORD = ")[^"]*/\SYSMANPASSWORD = "123456/g' dbca.rsp
    sed -ri 's/(#DBSNMPPASSWORD = ")[^"]*/\DBSNMPPASSWORD = "123456/g' dbca.rsp
    sed -ri 's/(#DATAFILEDESTINATION = ")[^"]*/\DATAFILEDESTINATION =\/data\/u01\/app\/oracle\/oradata/g' dbca.rsp
    sed -ri 's/(#RECOVERYAREADESTINATION = ")[^"]*/\RECOVERYAREADESTINATION=\/data\/u01\/app\/oracle\/fast_recovery_area/g' dbca.rsp
    sed -ri 's/(#CHARACTERSET = ")[^"]*/\CHARACTERSET = "AL32UTF8/g' dbca.rsp
    sed -ri 's/(#TOTALMEMORY = ")[^"]*/\TOTALMEMORY = "6144/g' dbca.rsp
    exit;
EOF
}

#查看建库响应文件，启用配置，以静默方式建立新库及实例
Silent_dbca_rsp()
{
    su - oracle <<EOF
    echo "egrep -v \"(^#|^$)\" /home/oracle/response/dbca.rsp"
    dbca -silent -responseFile /home/oracle/response/dbca.rsp
    ps -ef | grep ora_ | grep -v grep
    env|grep ORACLE_UNQNAME
    exit;
EOF
}

#以sysdba身份登陆并启动oracle数据库
Oracle_sysdba_start()
{
    su - oracle <<EOF
    sqlplus / as sysdba
    startup
    ps -aux |grep oracle
    exit;
EOF
}
