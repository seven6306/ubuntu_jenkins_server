#!/bin/bash
Notification()
{
    read -p "$1" ans
    case $ans in
        y*|Y*) printf "$2";;
        *) exit 0;;
    esac
}

