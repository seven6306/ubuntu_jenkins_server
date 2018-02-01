#!/bin/bash
# Script for ubuntu 14.04 LTS
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
NC='\033[0m'
LINE='============================================================================='
Notification()
{
	local package=$1
    printf "${LINE}\n"
    printf "${PURPLE}$package download and setup starting:${NC}\n"
    printf "${LINE}\n"
}
NetworkConnTest()
{
	local website=$1
    ping $website -c 1 -q >> /dev/null 2>&1
    [ $? -ne 0 ] && printf "%s\t%35s\033[0;31m %s \033[0m]\n" " * Network connection test" "[" "Fail" && exit 1
	printf "%s\t%35s\033[0;32m %s \033[0m]\n" " * Network connection test" "[" "OK"
	return 0
}
NetworkConnTest www.google.com
Notification "Oracle Java 8"
add-apt-repository ppa:webupd8team/java -y
apt-get update
apt-get install oracle-java8-installer -y
apt-get install oracle-java8-set-default -y
JavaVer=`java -version 2>&1 | grep "java version" | awk -F\" '{print $2}'`
printf "${LINE}\n"
printf "Oracle Java Version: [ ${RED}${JavaVer}${NC} ]\n"
Notification Jenkins
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install jenkins -y
printf "${LINE}\n"
service jenkins start
cat /var/lib/jenkins/secrets/initialAdminPassword
