#!/usr/bin/python
from sys import argv
from socket import socket, AF_INET, SOCK_DGRAM

def gethostIPaddr(dst, port):
    try:
        host = socket(AF_INET, SOCK_DGRAM)
        host.connect((dst, port))
        ip = host.getsockname()[0]
        host.close()
        return ip
    except Exception as err:
        print str(err)
        raise ImportError

if __name__ == '__main__':
    try:
        if len(argv) == 2:
            IP, Port = argv[1].split(':')[0], argv[1].split(':')[1]
        else:
            IP, Port = '8.8.8.8', 80
        print gethostIPaddr(IP, int(Port))
    except ImportError:
        SystemExit(255)
    except:
        print 'Usage: python gethostIPaddr.py [Dst_IP:Port]\n       e.g., python gethostIPaddr.py 8.8.8.8:80'
