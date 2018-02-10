#!/usr/bin/python
from sys import argv
from os import remove
from os.path import isfile
from getpass import getpass

if __name__ == '__main__':
    if len(argv) > 1:
        message, username = argv[1], ''
        print message
        while(username == ''):
            username = raw_input('Enter username: ')
        while(True):
            password1 = getpass('Enter password: ')
            password2 = getpass('Re-enter password: ')
            if not password1 or not password2:
                print '\033[0;31mERROR: incorrect password format.\033[0m'
                continue
            elif password1 != password2:
                print '\033[0;31mERROR: password do not match.\033[0m'
                continue
            break
        if len(argv) > 2:
            if argv[2] == '--showinfo':
                print '{0};{1}'.format(username, password1)
        if isfile('/tmp/account.cache'):
            remove('/tmp/account.cache')
        with open('/tmp/account.cache', 'w') as cache:
            cache.write('username={0};password1={1}'.format(username, password1))
    else:
        print 'Usage: python user_creator.py [Message] --showinfo'
