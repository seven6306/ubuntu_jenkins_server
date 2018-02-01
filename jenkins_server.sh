#!/bin/bash
# Script for ubuntu 14.04 LTS
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
NC='\033[0m'
COUNTER=10
LINE='============================================================================='
CheckPermission()
{
    local tmpfile=/etc/init.d/request.tmp
    touch $tmpfile >> /dev/null 2>&1
    [ $? -ne 0 ] && printf "\033[0;31mERROR: Permission denied, try \'sudo\' to execute the script.\033[0m\n" && exit 1
    printf "%s\t%31s\033[0;32m %s \033[0m]\n" " * Check root permission in executed" "[" "OK"
    rm -f $tmpfile
    return 0
}    
NetworkConnTest()
{
    local website=$1
    ping $website -c 1 -q >> /dev/null 2>&1
    [ $? -ne 0 ] && printf "%s\t%31s\033[0;31m %s \033[0m]\n" " * Network connection test       " "[" "Fail" && exit 1
    printf "%s\t%31s\033[0;32m %s \033[0m]\n" " * Network connection test         " "[" "OK"
    return 0
}
Notification()
{
    read -p "$1" ans
    case $ans in
        y*|Y*) printf "$2";;
        *) exit 0;;
    esac
}
CheckPermission && NetworkConnTest www.google.com
Notification "Setup jenkins server will take 10-15 minutes, Are you sure? [y/N]: " "${LINE}\n${PURPLE}Oracle Java 8 download and setup starting:${NC}\n${LINE}\n"
add-apt-repository ppa:webupd8team/java -y
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install oracle-java8-installer -y || sudo dpkg --configure -a
apt-get install oracle-java8-set-default -y || sudo dpkg --configure -a
[ `dpkg -l | awk '{print $2}' |  grep -c oracle-java8-installer` -eq 0 ] && printf "${RED}ERROR: Required package \"Oracle Java 8\" is not installed.${NC}\n" && exit 1
printf "${LINE}\n\t\t\t${RED}Java installed end line${NC}\n"
printf "${LINE}\n${PURPLE}Jenkins download and setup starting:${NC}\n${LINE}\n"
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install jenkins -y || sudo dpkg --configure -a
service jenkins start
while [ $COUNTER != 0 ]
do  for i in '.' '..' '...' '....'
    do  printf "${PURPLE}Getting initial admin password${i}${NC}\n"
        sleep 2
        tput cuu1 && tput el
		[ -f /var/lib/jenkins/secrets/initialAdminPassword ] && initPasswd=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` && break
    done
	[ ! -z $initPasswd ] && break
    COUNTER=$(($COUNTER - 1))
    printf "Retry times remain: ${RED}${COUNTER}${NC}\n" && sleep 2
done
JavaVer=`java -version 2>&1 | grep "java version" | awk -F\" '{print $2}'`
host=`ip a | awk '{print $2}' | grep -v '127.0.0.1' | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}"`
[ `service jenkins status | grep -co not` -ne 0 ] && printf "\n${RED}Sorry, jenkins server is unavailable...${NC}\n\n" && exit 1
printf "${LINE}\n\n${PURPLE}Packages Install Info:${NC}\n * Oracle Java Version:  \t[ ${GREEN}${JavaVer}${NC} ]\n"
printf " * Jenkins Server Status:\t[ ${GREEN}Running${NC} ]\n"
[ -z $initPasswd ] && printf " * Get Initial Admin Password:\t[ ${RED}Fail${NC} ]\n\n" && initPasswd=None || printf " * Get Initial Admin Password:\t[ ${GREEN}OK${NC} ]\n\n"
printf "${LINE}\n\n${PURPLE}Jenkins Server Info:${NC}\n * Server site - ${GREEN}http://${host}${NC}${RED}:8080${NC}\n * Init Password - ${RED}${initPasswd}${NC}\n\n"

