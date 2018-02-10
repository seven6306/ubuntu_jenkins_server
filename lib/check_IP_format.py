#!/usr/bin/python
from sys import argv
from os import system
from socket import inet_aton

def valid_ip(Addr):
    try:
        Addr2, tmp_Addr = '', []
        inet_aton(Addr)
        [tmp_Addr.append(int(i)) for i in Addr.split('.')]
        Addr2 = ''.join('{0}{1}.'.format(Addr2, str(j)) for j in tmp_Addr)[:-1]
        if system('ping -q {} -c 1 >> /dev/null 2>&1'.format(Addr2)) != 0:
            raise Exception
        return Addr2
    except:
        return False
if __name__ == '__main__':
    if len(argv) > 1:
        print valid_ip(argv[1])
    else:
        print 'Usage: python check_IP_format.py [IPAddr]'
