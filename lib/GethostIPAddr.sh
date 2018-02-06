#!/bin/bash
GethostIPAddr()
{
    local ipAddr=`ip a | awk '{print $2}' | grep -v '127.0.0.1' | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | sed -n 1p`
    printf $ipAddr
}
