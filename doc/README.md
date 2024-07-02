-   [Intro](#intro)
-   [Quickstart](#quickstart)
    -   [Requirements](#requirements)
    -   [Starting the probe](#starting-the-probe)
    -   [Starting the collect of data](#starting-the-collect-of-data)
-   [State Machine of the system](#state-machine-of-the-system)
-   [Agent Oriented Programming](#agent-oriented-programming)
-   [Documentation of each scripts](#documentation-of-each-scripts)

Intro
=====

This project is an implementation of such a way of thinking distributed
system. For sake of education I took the most compact language for the
task : *bash*

We are gonne realize on this principle a Fast Adaptative Insecure
Monitoring system.

FAIM is designed as a funny experiment of doing a munin clone (doing
less) in bash only that is specialized in high speed (\~1 seconde /
measure) distributed measuring system without a centralized collector.

No broker, no Zmq, no webrtc, no QUIC, no rabbitMQ are used for
transport but \... BROADCAST UDP.

Hence, well, this toy is fondamentally insecure and can hardly be
ciphered in its current form. But, it enables a category of software
that are both educational for doing your own tool AND for deploying an
adhoc measuring system.

[Read full documentation
here](https://github.com/jul/FAIM/tree/main/doc)

![example](./img/example.png)

Quickstart
==========

Requirements
------------

Perl, python3, gnuplot (gnuplot-lite maybe enough if 1Gb dependency
rebukes you), bash, socat, and whatever the plugins have dependencies
upon.

Starting the probe
------------------

    ./start.sh

Starts the probe. It will emit (see API of start for network parameters)
on the UDP broadcast address in ASCII excactly what `bin/writer.sh`
emits on stdout.

To stop the probe simply type

    ./stop.sh

Starting the collect of data
----------------------------

    LURKER=1 ./start.sh

Will start the probe AND the data collector. The data collector can also
be caught in a standalone mode with `./bin/launch_lurker.sh` or
` ./bin/launch_lurker.py`.

if you go in ./data/ you will see both csv where data are stored
accumulating and the making of the html resume.

Just open ./data/index.html to view the graphs.

You can erase the content of data at any moment, everything will
reconstruct itself.

What the lurker sees from the broadcast is log into ./log/journal.txt.

CSV files and html can be reconstructed by typing

     cat log/journal.log | bin/lurker
     bin/mkhtml.sh

mkhtml is the bash equivalent of PHP or using jinja in python : dynamic
html generation.

I seriously advise to install tcpdump, and remember that
` tcpdump -A [-i interface] -s0 udp and port 6666` can be a serious life
saviour while troubleshooting.

State Machine of the system
===========================

      +----------------------------------------------------------------------+
      |                                                                      |
      |                END:kills                                             |
      |    +---------------------------------------------+                   +--------------------------------------------------------+
      |    v                                             |                                                                            |
      |  +-----------+   exec itself each n seconds    +------------------+              +------------------+                       +----------------------------------------+
      |  |           | -----------------------------+  |                  |              |                  |                       |                                        |
      |  | mkhtml.sh |                              |  |     stop.sh      |  END:kills   | launch\_lurker.sh|  BEGIN:launches       |                start.sh                |
      |  |           | <----------------------------+  |                  | -----------> |                  | <-------------------- |                                        | -----------------------------------------------+
      |  +-----------+                                 +------------------+              +------------------+                       +----------------------------------------+                                                |
      |    ^                                             |                                 |                                          |                                                                                       |
      |    | launches                                    | END:kills                       |                                          | launches                                                                              |
      |    |                                             v                                 |                                          v                                                                                       |
      |    |                                           +------------------+                |                     0-n:sleep          +----------------------------------------+                                                |
      |    |                                           |                  |                |                   +------------------- |                                        |                                                |
      |    |           BEGIN:launches                  | launch\_writer.sh|                |                   |                    |                clock.sh                |                                                |
      +----+-----------------------------------------> |                  |                |                   +------------------> |                                        | <+                                             |
           |                                           +------------------+                |                                        +----------------------------------------+  |                                             |
           |                                             |                                 |                                          |                                         |                                             |
           |                                             |                                 |                                          | 1:signals                               | 3:writer:on competion:signal speed change   |
           |                                             |                                 |                                          v                                         |                                             |
           |                                             |                                 |                  connect to network    +----------------------------------------+  |                                             |
           |                                             +---------------------------------+--------------------------------------> |               writer.sh                | -+                                             |
           |                                                                               |                                        +----------------------------------------+                                                |
           |                                                                               |                                          |                                                                                       |
           |                                                                               |                                          | 2:writer:on clock signal:send measure                                                 |
           |                                                                               |                                          v                                                                                       |
           |                                                                               |                  connect to network    +----------------------------------------+                                                |
           |                                                                               +--------------------------------------> |               lurker.sh                |                                                |
           |                                                                                                                        +----------------------------------------+                                                |
           |                                                                                                                                                                                                                  |
           +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

![diag](./img/diag.png)

Agent Oriented Programming
==========================

1.  EverythingIsAnAgent

2.  Agent communicate by sending and receiving messages (the way they
    prefer as long as they send messages).

3.  Agent have their own memory and autonomy

4.  Every Agent is an instance of an artifact (which then as to be
    accounted as an agent).

5.  The Agent is accountable for maintaining its consistency as a
    state/transition agent

6.  The topology is more important than the code.

7.  each state machine is on a plane for which an uncoupled state
    machine lays.

8.  violation of uncoupling between layers is bad so it has to be
    handled with care.

Documentation of each scripts
=============================

API of each components.

-   [./bin/asci\_plot.sh](http:././bin/asci_plot.sh.html)
-   [./bin/basic\_plot.sh](http:././bin/basic_plot.sh.html)
-   [./bin/clock.sh](http:././bin/clock.sh.html)
-   [./bin/launch\_lurker.sh](http:././bin/launch_lurker.sh.html)
-   [./bin/launch\_writer.sh](http:././bin/launch_writer.sh.html)
-   [./bin/lurker.sh](http:././bin/lurker.sh.html)
-   [./bin/mkhtml.sh](http:././bin/mkhtml.sh.html)
-   [./bin/plot\_histo.sh](http:././bin/plot_histo.sh.html)
-   [./bin/plot\_histo\_g.sh](http:././bin/plot_histo_g.sh.html)
-   [./bin/plot\_rrd2.sh](http:././bin/plot_rrd2.sh.html)
-   [./bin/writer.sh](http:././bin/writer.sh.html)
-   [./mkdoc.sh](http:././mkdoc.sh.html)
-   [./plugin/cpu](http:././plugin/cpu.html)
-   [./plugin/ibm\_acpi](http:././plugin/ibm_acpi.html)
-   [./plugin/ibm\_acpi\_fan](http:././plugin/ibm_acpi_fan.html)
-   [./plugin/irq](http:././plugin/irq.html)
-   [./plugin/open\_files](http:././plugin/open_files.html)
-   [./plugin/processes](http:././plugin/processes.html)
-   [./plugin/stat](http:././plugin/stat.html)
-   [./plugin/tcp](http:././plugin/tcp.html)
-   [./pubsub.sh](http:././pubsub.sh.html)
-   [./start.sh](http:././start.sh.html)
-   [./stop.sh](http:././stop.sh.html)
