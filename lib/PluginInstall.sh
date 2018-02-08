#!/bin/bash.
PluginInstall()
{
    [ ! -f suggested_plugin_list.json ] && printf "${RED}ERROR: file suggested_plugin_list.json is missing.${NC}\n" && exit 1
    case $1 in
        sug) local regx='\"suggested\": true';;
        full) local regx='\"name\": ';;
    esac
    printf "\n${LINE}\n${PURPLE}Starting install Jenkins suggested plugins:${NC}\n${LINE}\n"
    for plugin in `grep -E $regx suggested_plugin_list.json | awk -F\" '{print $4}'`
    do  java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://`GethostIPAddr`:8080/ install-plugin $plugin
    done
    printf "\n${LINE}\n\n" && return 0
}
