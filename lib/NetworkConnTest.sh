#!/bin/bash
NetworkConnTest()
{
    local website=$1
    ping $website -c 1 -q >> /dev/null 2>&1
    [ $? -ne 0 ] && printf "%s\t%31s\033[0;31m%s\033[0m]\n" " * Network connection test       " "[" "Fail" && exit 1
    printf "%s\t%31s\033[0;32m %s \033[0m]\n" " * Network connection test         " "[" "OK"
    return 0
}

