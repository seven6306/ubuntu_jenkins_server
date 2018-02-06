#!/bin/bash
CheckInstall()
{
    local pkgName=$1
    local action=$2
    local file=$3
    local dir=$4
    local x=0
    for f in `echo $file | sed 's,\,, ,g'`
    do  [ -f $f ] && x=$(($x+1))
    done
    for d in `echo $dir | sed 's,\,, ,g'`
    do  [ -d $d ] && x=$(($x+1))
    done
    case $action in
        --install) [ $x -ne 0 ] && printf "\033[0;31mERROR: $pkgName is already installed.\033[0m\n" && exit 1;;
        --remove)  [ $x -ne 0 ] && printf "\033[0;31mERROR: $pkgName is not installed.\033[0m\n" && exit 1;;
    esac
    printf "%s\t%31s\033[0;32m %s \033[0m]\n" " * Check if $pkgName is installed      " "[" "OK"
    return 0
}

