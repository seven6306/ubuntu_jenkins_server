#!/bin/bash.
. lib/GethostIPAddr.sh
PluginInstall()
{ 
    case $1 in
        sug) local regx='\"suggested\": true';;
        all) local regx='\"name\": ';;
    esac
    for plugin in `grep -E $regx suggested_plugin_list.json | awk -F\" '{print $4}'`
    do  java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://`GethostIPAddr`:8080/ install-plugin $plugin
    done
    return 0
}
