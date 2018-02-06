#!/bin/bash
CheckPermission()
{
    local tmpfile=/etc/init.d/request.tmp
    touch $tmpfile >> /dev/null 2>&1
    [ $? -ne 0 ] && printf "\033[0;31mERROR: Permission denied, try \'sudo\' to execute the script.\033[0m\n" && exit 1
    printf "%s\t%31s\033[0;32m %s \033[0m]\n" " * Check root permission in executed" "[" "OK"
    rm -f $tmpfile
    return 0
}

