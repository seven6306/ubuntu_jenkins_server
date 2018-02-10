#!/usr/bin/python

with open('README.md') as rf:
    data = rf.read().split('```')
for each_line in data[1].replace('javascript\n','').split('\n'):
    print each_line
