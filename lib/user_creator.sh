#!/bin/bash
user_creator()
{
    local message="$1"
    printf "${message}\n"
    while [ -z $username ]
    do  read -p "Enter username: " username
    done
    while :
    do  stty -echo
        read -p "Enter password: " password1 && echo
        read -p "Re-enter password: " password2 && echo
        stty echo
        [ -z "${password1}" -o -z "${password2}" ] && printf "\033[0;31mERROR: incorrect password format.\033[0m\n" && continue
        [ "${password1}" != "${password2}" ] && printf "\033[0;31mERROR: password do not match.\033[0m\n" && continue
        break
    done
    return 0
}
