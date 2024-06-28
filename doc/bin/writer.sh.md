-   [NAME](#NAME)
    -   [SYNOPSIS](#SYNOPSIS)
    -   [OPTIONS](#OPTIONS)

NAME {#NAME}
====

    writer.sh

SYNOPSIS {#SYNOPSIS}
--------

Emitter of data

    [TICK=2] ./writer.sh

OPTIONS {#OPTIONS}
-------

For explanation of options see <file:../start.sh.html>

If TICK is set then writer will assume it is to be launched in
conjunction with <file:./clock.sh.html> and do nothing until clock.sh
sends a signal to it to write data.
