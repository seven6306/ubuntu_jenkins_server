#!/usr/bin/python
from sys import argv

def printUsage(fileName):
    try:
        with open(fileName) as rf:
            data = rf.read().split('```')
        for each_line in data[1].replace('javascript\n','').split('\n'):
            print each_line
    except IOError as ioerr:
        print str(ioerr)
if __name__ == '__main__':
    if len(argv) == 2:
        fileName = argv[1]
        printUsage(fileName)
    else:
        print 'Usage: python print_usage.py [README.md]'
