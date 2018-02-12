#!/bin/bash
Notification()
{
    read -p "$1" ans
    case $ans in
        y*|Y*) printf "$2" && return 0;;
        *) return 1;;
    esac
}
