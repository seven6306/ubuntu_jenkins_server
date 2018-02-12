SSLconfigure()
{
    if [ $NOASK -eq 0 ]; then
        python lib/notification.py "Configure jenkins server with SSL? (default:No) [y/N] : " "${PURPLE}Configuring SSL settings...${NC}\n${LINE}\n\n" || return 5
    fi
    python lib/checkInstall.py nginx --remove "/etc/init.d/nginx,/usr/sbin/nginx,/usr/share/nginx,/etc/nginx/sites-enabled/default"
    [ `grep -cE "proxy_redirect|proxy_read_timeout|https://" /etc/nginx/sites-enabled/default` -ne 0 ] && printf "${RED}ERROR: Jenkins server is already configure to SSL.${NC}\n" && return 1
    sed -i 's,try_files $uri $uri/ =404;,# try_files $uri $uri/ =404;,g' /etc/nginx/sites-enabled/default
    for each_line in "proxy_redirect      http://localhost:8080 https://`python lib/gethostIPaddr.py`;" 'proxy_read_timeout  90;' 'proxy_pass          http://localhost:8080;' '# Fix the “It appears that your reverse proxy set up is broken" error.'
    do  sed -i "/\#\ include\ \/etc\/nginx\/naxsi\.rules/ a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ${each_line}" /etc/nginx/sites-enabled/default
    done
    sed -i 's,\--webroot=\/var\/cache\/$NAME\/war\ \--httpPort=\$HTTP_PORT,\--webroot=\/var\/cache\/$NAME\/war\ \--httpPort=\$HTTP_PORT\ \--httpListenAddress=127\.0\.0\.1\ \-ajp13Port=\$AJP_PORT,g' /etc/default/jenkins
    service nginx restart
    service jenkins restart
    case $? in
        0) printf "%s\t%34s\033[0;32m %s \033[0m]\n" " * Configure jenkins server with SSL" "[" "OK" && PORT=443 && PROTOCOL=https
           printf " * Jenkins site - ${GREEN}https://`python lib/gethostIPaddr.py`${NC}${RED}:${PORT}${NC} (https)\n\n";;
        *) printf "%s\t%34s\033[0;31m%s\033[0m]\n\n" " * Configure jenkins server with SSL" "[" "Fail" && exit 1;;
    esac
}
