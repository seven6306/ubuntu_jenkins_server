#!/bin/bash
# Script for ubuntu 14.04 LTS
. lib/declare_variables.sh

[ "$1" = "-h" -o "$1" = "--help" ] && printf "Usage: sh update_server_IP.sh [OPTION]\n       -q,   --quiet       Force to update jenkins server IP address.\n" && exit 0
python lib/checkPermission.py || exit 1
python lib/checkInstall.py "jenkins_nginx" --remove "/etc/init.d/jenkins,/usr/sbin/nginx,/var/lib/jenkins,/usr/share/jenkins,/etc/nginx,/usr/share/nginx" || exit 1
case $1 in
    -q|--quiet) server_name=`python lib/gethostIPaddr.py`;;
    *) printf "To update jenkins server name (Default: localhost),\n" && read -p "please input IP or domain name: " server_name;;
esac
[ -z $server_name ] && printf "\n${PURPLE}Loading default value: localhost ...${NC}\n\n" && server_name=`python lib/gethostIPaddr.py`
if [ `python lib/check_IP_format.py $server_name | grep -coE "^([0-9]{1,3}\.){3}[0-9]{1,3}$"` -eq 0 ]; then
    if [ `echo $server_name | grep -cE "^([a-zA-Z_]+\.){1,2}[a-zA-Z_]+"` -eq 0 ]; then
        printf "${RED}ERROR: Invalid domain or IP address format.${NC}\n" && exit 1
    fi
fi
sed -i "s,`grep -E "server_name \w+*" /etc/nginx/sites-enabled/default | grep -vE "^#\s+.*server_name"`,\ \ \ \ \ \ \ \ server_name\ ${server_name};,g" /etc/nginx/sites-enabled/default
sed -i "s,`grep 'proxy_redirect      http://localhost:8080' /etc/nginx/sites-enabled/default`,\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ proxy_redirect\ \ \ \ \ \ http\:\/\/localhost\:8080 https:\/\/${server_name};,g" /etc/nginx/sites-enabled/default
service nginx restart
service jenkins restart
printf " * Jenkins site - ${GREEN}https://${server_name}${NC}${RED}:443${NC}\n\n"
