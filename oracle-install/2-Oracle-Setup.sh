#!/bin/bash
# Author: jiang liang
# Date: 2018-08-09
# Description: Begin to prepare cloudera environment
. $(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/Oracle-Install.sh

env_prepare()
{
Setup_Oracle
}

env_prepare 2>&1 | tee Setup_Oracle.log
