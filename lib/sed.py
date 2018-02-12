#!/usr/bin/python
from sys import argv
from os import remove
from shutil import copy

def sed(src, dst, file, action):
    try:
        if '-bak' in action:
            copy(file, file + '.bak')
        with open(file) as rf:
            tmp_data = []
            data = rf.read().split('\n')
            for each_line in data:
                if '--replace' in action:
                    tmp_data.append(each_line.replace(src, dst))
                elif '--after' in action:
                    tmp_data.append(each_line)
                    if src in each_line:
                        for e in dst.split('|'):
                            tmp_data.append(e)
        remove(file)
        with open(file, 'a') as wf:
            for each_line in tmp_data:
                wf.write(each_line + '\n')
        return True
    except Exception as err:
        print '\033[0;31m{}\033[0m'.format(str(err))
        return False

if __name__ == '__main__':
    try:
        if len(argv) == 5:
            src, dst, file, action = argv[1], argv[2], argv[3], argv[4]
            if not sed(src, dst, file, action):
                raise SystemExit(3)
    except:
        print """Usage: python sed.py [PATTERN1] [PATTERN2] [FILE] [OPTION-bak]
   e.g., python sed.py 'try_files $uri $uri/ =404;' '#try_files $uri $uri/ =404;' default --replace
   e.g., python sed.py '        ## interface' '        eth0|        localhost' default --after-bak
"""
