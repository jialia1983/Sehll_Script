#!/bin/bash
# Author: jiangliang
# Date: 2017-05-08
# Description: Begin to prepare cloudera environment
. $(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/Oracle-Install.sh

env_prepare()
{
Install_Oracle_rely_on
Create_Oracle_user_group
Create_Oracle_install_mkdir
Unzip_Oracle
Create_Oracle_mkdir
Modify_the_kernel
Modify_the_user
Modify_pam_login
Modify_root_profile
Modify_oracle_bash_profile
Modify_db_install_rsp
}

env_prepare 2>&1 | tee Modify-Configure.log

