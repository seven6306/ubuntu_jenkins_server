# Ubuntu_Jenkins_Server

## Description
* *One click to install Jenkins server*
* *Support SSL protocol to server*
* *Provide manual install plugin user's prefer*

## Script Usage

```javascript
Usage:
      Script additional functions notice:
      You nust be use below listed options after Jenkins has been
      installed.

      sh jenkins_server.sh [OPTION] [ARGV1]
      -h, --help    Show script usage
      -u, --update  Manual update jenkins server IP address
                    --quiet      Force to update
      e.g., sh jenkins_server.sh -u --quiet

      -p, --plugin  Install Jenkins plugin with [ARGV1]
                    --suggested  Suggested plugins
                    --full       Full install
      e.g., sh jenkins_server.sh -p --suggested
```
pass=`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` && echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("allen", "123456")' | sudo java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:$pass -s http://192.168.38.189:8080/ groovy =
