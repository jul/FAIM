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

This project is an implementation of such a way of thinking distributed
system. For sake of education I took the most compact language for the
task : *bash*

We are gonne realize on this principle a Fast Adaptative Insecure
Monitoring system.

FAIM is designed as a funny experiment of doing a munin clone (doing
less) in bash only that is specialized in high speed (\~1 seconde /
measure) distributed measuring system without a centralized collector.

No broker, no Zmq, no webrtc, no QUIC, no rabbitMQ are used for
transport but ... BROADCAST UDP.

Hence, well, this toy is fondamentally insecure and can hardly be
ciphered in its current form.

But, it enables a category of software that are both educational for
doing your own tool AND for deploying an adhoc measuring system.

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

-   [./bin/asci\_plot.sh](./bin/asci_plot.sh.md)
-   [./bin/basic\_plot.sh](./bin/basic_plot.sh.md)
-   [./bin/clock.sh](./bin/clock.sh.md)
-   [./bin/launch\_lurker.sh](./bin/launch_lurker.sh.md)
-   [./bin/launch\_writer.sh](./bin/launch_writer.sh.md)
-   [./bin/lurker.sh](./bin/lurker.sh.md)
-   [./bin/mkhtml.sh](./bin/mkhtml.sh.md)
-   [./bin/plot\_histo.sh](./bin/plot_histo.sh.md)
-   [./bin/plot\_histo\_g.sh](./bin/plot_histo_g.sh.md)
-   [./bin/plot\_rrd2.sh](./bin/plot_rrd2.sh.md)
-   [./bin/writer.sh](./bin/writer.sh.md)
-   [./index](./index.md)
-   [./mkdoc.sh](./mkdoc.sh.md)
-   [./plugin/cpu](./plugin/cpu.md)
-   [./plugin/ibm\_acpi](./plugin/ibm_acpi.md)
-   [./plugin/ibm\_acpi\_fan](./plugin/ibm_acpi_fan.md)
-   [./plugin/irq](./plugin/irq.md)
-   [./plugin/open\_files](./plugin/open_files.md)
-   [./plugin/processes](./plugin/processes.md)
-   [./plugin/stat](./plugin/stat.md)
-   [./plugin/tcp](./plugin/tcp.md)
-   [./pubsub.sh](./pubsub.sh.md)
-   [./start.sh](./start.sh.md)
-   [./stop.sh](./stop.sh.md)
