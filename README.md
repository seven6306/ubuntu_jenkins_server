# Ubuntu_Jenkins_Server

## Description
* *One click to install Jenkins server*
* *Support SSL protocol to server*
* *Provide manual install plugin user's prefer*

## How to update server IP or domain

```javascript
Usage:
      Script additional function notice:
      You nust be use below listed options after Jenkins has been
      installed.

      sh jenkins_server.sh [OPTION] [ARGV1]
      -h, --help    Show script usage
      -u, --update  Manual update jenkins server IP address
                    --quiet      Force to update
      -p, --plugin  Install Jenkins plugin with [ARGV1]
                    --suggested  Suggested plugins
                    --full       Full install
      e.g., sh jenkins_server.sh -p --suggested
```

