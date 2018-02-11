# Ubuntu_Jenkins_Server

## Description
* *One command line to quickly install Jenkins server*
* *Support SSL protocol to server*
* *Provide manual install plugin user's prefer*
* *Create Jenkins admin user customize*

## How to use it

```javascript
Usage:
      Script additional functions notice:
      Before use below listed options, make sure Jenkins has been
      installed.

      sh jenkins_server.sh [OPTION] [ARGV1]
      -y, --yes     No required question but user create
                    username=[adminUser] password=[adminPassword]
      e.g., sh jenkins_server.sh -y username=test password=123456

      -h, --help    Show script usage
      -c, --create  Create an admin user after Jenkins installed
                    username=[adminUser] password=[adminPassword]
      e.g., sh jenkins_server.sh -c username=test password=123456

      -u, --update  Manual update jenkins server IP address
                    --quiet      Force to update
      e.g., sh jenkins_server.sh -u --quiet

      -p, --plugin  Install Jenkins plugin with [ARGV1]
                    --suggested  Suggested plugins
                    --full       Full install
      e.g., sh jenkins_server.sh -p --suggested
```

