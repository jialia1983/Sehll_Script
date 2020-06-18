#!/bin/bash
# Author: jiang liang
# Date: 2018-08-09
. $(cd $(dirname "${BASH_SOURCE[0]}") && pwd)/Oracle-Install.sh
Sysdba_start()
{
    Oracle_sysdba_start    
}
Sysdba_start 3>&1 | tee Sysdba_start.log
