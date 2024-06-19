#!/usr/bin/env python3
from socket import *
import os
os.chdir(os.path.dirname(__file__))
r=socket(AF_INET, SOCK_DGRAM)
import subprocess
r.bind(('',6666))
s=socket(AF_INET, SOCK_DGRAM)
s.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
while True:
    m=r.recvfrom(1024)
    res=subprocess.run(["./writer.sh"], stdout=subprocess.PIPE)
    s.sendto(res.stdout,( "192.168.1.255", 6666 ))

