#!/bin/bash
# Author: jiang liang
# Date: 2018-08-09                                           
# Description: Begin to prepare cloudera environment            
. $(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/Oracle-Install.sh  

Check_Oracle_dbca()
{
    Modify_sh
    Modify_netca_rsp
    Start_Oracle
    Modify_dbca_rsp
    Silent_dbca_rsp
}

Check_Oracle_dbca 3>&1 | tee Check_Oracle_dbca.log
