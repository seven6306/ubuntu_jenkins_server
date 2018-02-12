#!/usr/bin/python
from apt import Cache
from sys import argv, exit
from os.path import isfile, isdir

def checkInstall(pkgName, action, files):
    x, f_list, apt_cache = 0, files.split(','), Cache()
    try:
        if apt_cache[pkgName].is_installed:
            x = x + 1
    except:
        pass
    for i in f_list:
        if isfile(i) or isdir(i):
            x = x + 1
    if '--install' in action and x != 0:
        print "\033[0;31mERROR: {} is already installed.\033[0m".format(pkgName)
        return False
    elif '--remove' in action and x != len(f_list):
        print "\033[0;31mERROR: {} is not installed.\033[0m\n".format(pkgName)
        return False
    print "%s\t%34s\033[0;32m %s \033[0m]" % (" * Check if {} is installed      ".format(pkgName), "[", "OK")

if __name__ == '__main__':
    try:
        if len(argv) == 4:
            pkgName, action, files = argv[1], argv[2], argv[3]
            if action not in ['--install', '--remove']:
                raise SyntaxError
            if not checkInstall(pkgName, action, files):
                raise SystemExit
        else:
            raise SyntaxError
    except SystemExit:
        exit(2)
    except SyntaxError:
        print 'Usage: python checkInstall.py [Package] [Action] [Files]\n       e.g., python checkInstall.py Jenkins --remove "/etc/init.d/jenkins,/var/lib/jenkins,/usr/share/jenkins"' 
    except Exception as err:
        print str(err)
