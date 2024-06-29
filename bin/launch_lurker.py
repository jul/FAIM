#!/usr/bin/env python3
"""<< =cut

=head1 NAME

launch_lurker.py

=head2 SYNOPSYS

[HOST=0.0.0.0] [PORT=6666] ./launch_lurker

=head2 OPTIONS

see L<file:../start.sh.html> for explanation of the options
=back

=cut
"""
from fileinput import input
from socket import *
import os
from subprocess import Popen,PIPE
PORT=os.getenv("PORT") or 6666
PORT=int(PORT)
HOST=os.getenv("HOST") or "0.0.0.0"

os.chdir(os.path.dirname(__file__))
r=socket(AF_INET, SOCK_DGRAM)
r.bind((HOST,PORT))
s=socket(AF_INET, SOCK_DGRAM)
s.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)
with open("../pid/launch_lurker.py.pid", "w") as f: f.write(str(os.getpid()))
lurker = Popen("./lurker.sh", stdout=PIPE, stdin=PIPE, stderr=PIPE)
while True:
    m=r.recvfrom(1024)
    lurker.stdin.write(m[0])
    

