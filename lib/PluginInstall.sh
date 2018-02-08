#!/bin/bash.
PluginInstall()
{
    local Jcli=/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar
    [ ! -f suggested_plugin_list.json ] && printf "${RED}ERROR: file suggested_plugin_list.json is missing.${NC}\n" && exit 1
    case $1 in
        sug) local regx='\"suggested\": true';;
        full) local regx='\"name\": ';;
    esac
    printf "\n${LINE}\n${PURPLE}Starting install Jenkins suggested plugins:${NC}\n${LINE}\n"
    printf " * Backup jenkins config: ${RED}\"/var/lib/jenkins/config.xml\"${NC}\n * Unlock jenkins security to modify configuration.\n"
    sed -i.bak 's,\ \ <useSecurity>true</useSecurity>,\ \ <useSecurity>false</useSecurity>,g' /var/lib/jenkins/config.xml
    service jenkins restart
    sleep 60
    for plugin in `grep -E "$regx" suggested_plugin_list.json | awk -F\" '{print $4}'`
    do  java -jar $Jcli -s http://`GethostIPAddr`:8080/ install-plugin $plugin
    done
    rm -f /var/lib/jenkins/config.xml && cp -r /var/lib/jenkins/config.xml.bak /var/lib/jenkins/config.xml
    printf "${LINE}\n\n${PURPLE}Restoring jenkins config to security mode:${NC}\n"
    service jenkins restart
    printf "\n" && return 0
}
