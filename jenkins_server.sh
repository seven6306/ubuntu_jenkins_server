#!/bin/bash
# Script for ubuntu 14.04 LTS
. lib/print_usage.sh
. lib/user_creator.sh
. lib/CheckInstall.sh
. lib/Notification.sh
. lib/GethostIPAddr.sh
. lib/PluginInstall.sh
. lib/CheckPermission.sh
. lib/NetworkConnTest.sh
. lib/declare_variables.sh
NOASK=0
COUNTER=10
PORT=8080
PROTOCOL=http

[ "$1" = '?' -o "$1" = "-h" -o "$1" = "--help" ] && print_usage && exit 0
CheckPermission
if [ "$1" = "-y" -o "$1" = "--yes" ]; then
    [ "${}2" = "admin" ] && printf "${RED}ERROR: can not create super user.${NC}\n" && exit 1
    [ ! -z "${2}" -a ! -z "${3}" ] && [ `echo $2 | grep -c "username="` -ne 0 -a `echo $3 | grep -c "password="` -ne 0 ] && username=`echo $2 | cut -d \= -f2` && password1=`echo $3 | cut -d \= -f2`
    NOASK=1
fi
if [ $# -ne 0 -a $NOASK -ne 1 ]; then
    CheckInstall Jenkins --remove "/etc/init.d/jenkins" "/var/lib/jenkins,/usr/share/jenkins"
    case $1 in
    -c|--create)
        [ "${2}" = "admin" ] && printf "${RED}ERROR: user admin is already exists.${NC}\n" && exit 1
        [ ! -z "${2}" -a ! -z "${3}" ] && [ `echo $2 | grep -c "username="` -ne 0 -a `echo $3 | grep -c "password="` -ne 0 ] && username=`echo $2 | cut -d \= -f2` && password1=`echo $3 | cut -d \= -f2` ||　print_usage
        echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"${username}\", \"${password1}\")" | sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` -s http://localhost:8080/ groovy =
        [ $? -eq 0 ] && printf "%s\t%34s\033[0;32m %s \033[0m]\n\n" " * Apply new admin user to Jenkins  " "[" "OK" || printf "%s\t%34s\033[0;31m%s\033[0m]\n\n" " * Apply new admin user to Jenkins  " "[" "Fail";;
    -p|--plugin)
        case $2 in
        --suggested) PluginInstall sug;;
        --full) PluginInstall full;;
        * ) print_usage;;
        esac;;
    -u|--update) [ "$2" != "--quiet" ] && print_usage && exit 1
                 sh update_server_IP.sh -q;;
    * ) print_usage;;
    esac
    exit 0
fi
CheckInstall Jenkins --install "/etc/init.d/jenkins" "/var/lib/jenkins,/usr/share/jenkins"
NetworkConnTest www.google.com
if [ $NOASK -eq 0 ]; then
    Notification "Setup jenkins server will take 10-15 minutes, Are you sure? [y/N]: " "${LINE}\n${PURPLE}Oracle Java 8 download and setup starting:${NC}\n${LINE}\n" || exit 0
fi
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
[ `service jenkins status | grep -co not` -ne 0 ] && printf "\n${RED}Sorry, jenkins server is unavailable...${NC}\n\n" && exit 1
PluginInstall sug
if [ $NOASK -eq 0 ]; then
    Notification "Configure jenkins server with SSL? (default:No) [y/N] : " "${PURPLE}Configuring SSL settings...${NC}\n${LINE}\n\n"
    if [ $? -eq 0 ]; then
        if [ `dpkg -l | grep -c nginx` -gt 1 -a -f /etc/nginx/sites-enabled/default ]; then
            sed -i 's,try_files $uri $uri/ =404;,# try_files $uri $uri/ =404;,g' /etc/nginx/sites-enabled/default
            for each_line in "proxy_redirect      http://localhost:8080 https://`GethostIPAddr`;" 'proxy_read_timeout  90;' 'proxy_pass          http://localhost:8080;' '# Fix the “It appears that your reverse proxy set up is broken" error.'
            do  sed -i "/\#\ include\ \/etc\/nginx\/naxsi\.rules/ a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ${each_line}" /etc/nginx/sites-enabled/default
            done
            sed -i 's,\--webroot=\/var\/cache\/$NAME\/war\ \--httpPort=\$HTTP_PORT,\--webroot=\/var\/cache\/$NAME\/war\ \--httpPort=\$HTTP_PORT\ \--httpListenAddress=127\.0\.0\.1\ \-ajp13Port=\$AJP_PORT,g' /etc/default/jenkins
            service nginx restart
            service jenkins restart
            case $? in
                0) printf "%s\t%34s\033[0;32m %s \033[0m]\n\n" " * Configure jenkins server with SSL" "[" "OK" && PORT=443 && PROTOCOL=https;;
                *) printf "%s\t%34s\033[0;31m%s\033[0m]\n\n" " * Configure jenkins server with SSL" "[" "Fail" && exit 1;;
            esac
        else
            printf "\n${LINE}\n${RED}ERROR: Sorry, you must install nginx before configure SSL.${NC}\n\n"
        fi
    fi
fi
[ -z "${username}" -o -z "${password1}" ] && user_creator "${PURPLE}Create new admin user:${NC}"
printf "${PURPLE}Waiting for server apply admin user:${NC}\n"
sleep 60 && echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"${username}\", \"${password1}\")" | sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:${initPasswd} -s http://localhost:8080/ groovy =
[ $? -eq 0 ] && printf "%s\t%34s\033[0;32m %s \033[0m]\n\n" " * Apply new admin user to Jenkins  " "[" "OK" || printf "%s\t%34s\033[0;31m%s\033[0m]\n\n" " * Apply new admin user to Jenkins  " "[" "Fail"
printf "${LINE}\n\n${PURPLE}Packages Install Info:${NC}\n * Oracle Java Version:  \t[ ${GREEN}${JavaVer}${NC} ]\n"
printf " * Jenkins Server Status:\t[ ${GREEN}Running${NC} ]\n"
[ -z $initPasswd ] && printf " * Get Initial Admin Password:\t[${RED}Fail${NC}]\n\n" && initPasswd=None || printf " * Get Initial Admin Password:\t[ ${GREEN}OK${NC} ]\n\n"
printf "${LINE}\n\n${PURPLE}Jenkins Server Info:${NC}\n * Server site - ${GREEN}${PROTOCOL}://`GethostIPAddr`${NC}${RED}:${PORT}${NC}\n * Init Password - ${RED}${initPasswd}${NC}\n * Admin User - ${GREEN}${username}${NC}\n * Password - ${GREEN}`echo ${password1} | sed "s,.,*,g"`${NC}\n\n"
