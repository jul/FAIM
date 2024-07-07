# Quickstart

## Requirements

Perl, python3, gnuplot (gnuplot-lite maybe enough if 1Gb dependency rebukes you),
bash, socat, and whatever the plugins have dependencies upon.


## Starting the probe

```
./start.sh
```
Starts the probe. It will emit (see API of start for network parameters) on
the UDP broadcast address in ASCII excactly what `bin/writer.sh` emits on stdout.

To stop the probe simply type
```
./stop.sh
```

## Starting the collect of data

```
LURKER=1 ./start.sh
```

Will start the probe AND the data collector. The data collector can also
be caught in a standalone mode with ` ./bin/launch_lurker.sh ` or ` ./bin/launch_lurker.py`.

if you go in ./data/ you will see both csv where data are stored accumulating and the making of the html resume.

Just open ./data/index.html to view the graphs.

You can erase the content of data at any moment, everything will reconstruct itself.

What the lurker sees from the broadcast is log into ./log/journal.txt.

CSV files and html can be reconstructed by typing
```
 cat log/journal.log | bin/lurker
 bin/mkhtml.sh
```

mkhtml is the bash equivalent of PHP or using jinja in python : dynamic html generation.

I seriously advise to install tcpdump, and remember that ` tcpdump -A [-i interface] -s0 udp and port 6666` can be a serious life saviour while troubleshooting.


