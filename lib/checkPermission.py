#!/usr/bin/python
from sys import argv
from os import remove

def checkPermission(fileName):
    try:
        with open(fileName, 'w') as wf:
            wf.write('')
        remove(fileName)
        print "%s\t%34s\033[0;32m %s \033[0m]" % (" * Check root permission in executed", "[", "OK")
    except:
        print "\033[0;31mERROR: Permission denied, try 'sudo' to execute the script.\033[0m"
        raise SystemExit

if __name__ == '__main__':
    try:
        try:
            fileName = argv[1]
        except:
            fileName = '/etc/init.d/permission_request'
        checkPermission(fileName)
    except SystemExit:
        raise SystemExit(10)
    except:
        print 'Usage: python checkPermission.py [FileName]'
