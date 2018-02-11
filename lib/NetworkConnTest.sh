#!/bin/bash
NetworkConnTest()
{
    python lib/gethostIPaddr.py >> /dev/null 2>&1
    [ $? -eq 255 ] && printf "%s\t%34s\033[0;31m%s\033[0m]\n" " * Network connection test       " "[" "Fail" && exit 1
    printf "%s\t%34s\033[0;32m %s \033[0m]\n" " * Network connection test         " "[" "OK"
    return 0
}

