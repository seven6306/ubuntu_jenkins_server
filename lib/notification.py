#!/usr/bin/python
from sys import argv
from os import system

def notification(question, text):
    c = 3
    try:
        while(c != 0):
            c = c - 1
            ans = raw_input(question)
            if ans != '' and ans[0] in ['y', 'Y']:
                system('printf "{}"'.format(text))
                return True
            elif ans != '' and ans[0] in ['n', 'N']:
                return False
            else:
                print '\033[0;31mERROR: invalid answer, retry times remain: %d\033[0m' % c
        return False
    except KeyboardInterrupt:
        return False
if __name__ == '__main__':
    if len(argv) == 3:
        question, text = argv[1], argv[2]
        if not notification(question, text):
            raise SystemExit(5)
    else:
        print 'Usage: python notification.py [Question] [Text]'
