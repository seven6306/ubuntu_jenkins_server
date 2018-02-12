#!/usr/bin/python
from sys import argv
from apt import Cache
from os.path import isfile, isdir

def checkInstall(pkgName, action, files):
    x, y, f_list, apt_cache = 0, 0, files.split(','), Cache()
    try:
        for e in pkgName.split('_'):
            if apt_cache[e].is_installed:
                x, y = x + 1, y + 1
    except:
        pass
    for i in f_list:
        if isfile(i) or isdir(i):
            x = x + 1
    if '--install' in action and x != 0:
        print "\033[0;31mERROR: {} is already installed.\033[0m".format(pkgName)
        return False
    elif '--remove' in action and x != len(f_list)+y:
        print "\033[0;31mERROR: {} is not installed.\033[0m\n".format(pkgName)
        return False
    print "%s\t%34s\033[0;32m %s \033[0m]" % (" * Check if {} is installed      ".format(pkgName), "[", "OK")
    return True

if __name__ == '__main__':
    try:
        if len(argv) >= 3:
            pkgName, action  = argv[1], argv[2]
            try:
                files = argv[3]
            except:
                files = ''
            if action not in ['--install', '--remove']:
                raise SyntaxError
            if not checkInstall(pkgName, action, files):
                raise ImportError
        else:
            raise SyntaxError
    except ImportError:
        raise SystemExit(2)
    except SyntaxError:
        print """Usage: python checkInstall.py [Package] [Action] [Files]
       e.g., python checkInstall.py vim --install
       e.g., python checkInstall.py Jenkins --remove "/etc/init.d/jenkins,/var/lib/jenkins,/usr/share/jenkins"
"""
        raise SystemExit(3)
    except Exception as err:
        print str(err)
