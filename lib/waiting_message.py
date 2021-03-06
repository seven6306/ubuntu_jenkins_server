#!/usr/bin/python
from time import sleep
from sys import argv, stdout

def Waiting(message, delay):
    PURPLE, NC = '\033[1;35m', '\033[0m'
    for i in range(1,(int(delay) / 5) + 1):
        for j in range(1,5):
            if j == 1:
                stdout.write(PURPLE + message + ' ' + NC)
            stdout.write(PURPLE + '.'+' '+"\b" + NC)
            stdout.flush()
            sleep(1)
        stdout.write(PURPLE + ' '*(len(message)+5)+'\r' + NC)
        stdout.write(PURPLE + ' '*(len(message)+5)+'\r' + NC)
    print ''

if __name__ == '__main__':
    try:
        if len(argv) == 3:
            message, delay = argv[1], argv[2]
            if not delay.isdigit():
                raise Exception
            Waiting(message, delay)
    except:
        print 'Usage: python waiting_message.py [Message] [delay:seconds]'
