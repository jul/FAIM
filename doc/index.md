Agent Oriented Prgramming
=========================

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

-   [./bin/asci\_plot.sh](./bin/asci_plot.sh.html)
-   [./bin/basic\_plot.sh](./bin/basic_plot.sh.html)
-   [./bin/clock.sh](./bin/clock.sh.html)
-   [./bin/launch\_lurker.sh](./bin/launch_lurker.sh.html)
-   [./bin/launch\_writer.sh](./bin/launch_writer.sh.html)
-   [./bin/lurker.sh](./bin/lurker.sh.html)
-   [./bin/mkhtml.sh](./bin/mkhtml.sh.html)
-   [./bin/plot\_histo.sh](./bin/plot_histo.sh.html)
-   [./bin/plot\_histo\_g.sh](./bin/plot_histo_g.sh.html)
-   [./bin/plot\_rrd2.sh](./bin/plot_rrd2.sh.html)
-   [./bin/writer.sh](./bin/writer.sh.html)
-   [./index](./index.html)
-   [./mkdoc.sh](./mkdoc.sh.html)
-   [./plugin/cpu](./plugin/cpu.html)
-   [./plugin/ibm\_acpi](./plugin/ibm_acpi.html)
-   [./plugin/ibm\_acpi\_fan](./plugin/ibm_acpi_fan.html)
-   [./plugin/irq](./plugin/irq.html)
-   [./plugin/open\_files](./plugin/open_files.html)
-   [./plugin/processes](./plugin/processes.html)
-   [./plugin/stat](./plugin/stat.html)
-   [./plugin/tcp](./plugin/tcp.html)
-   [./pubsub.sh](./pubsub.sh.html)
-   [./start.sh](./start.sh.html)
-   [./stop.sh](./stop.sh.html)
