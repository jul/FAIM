-   [NAME](#NAME)
    -   [SYNOPSIS](#SYNOPSIS)
    -   [OPTIONS](#OPTIONS)

NAME {#NAME}
====

    mkhtml

    HTML maker

SYNOPSIS {#SYNOPSIS}
--------

Generator of HTML output from data collected in ../data

    [DAEMON=] [SINCE=3600] mkhtml.sh

Can be used as

    ./mkhtml.sh 

to generate the web page in ../data

OPTIONS {#OPTIONS}
-------

DAEMON

:   This code will run permanently waking itself up to update the web
    page.

SINCE

:   The window span time you are interested in in seconds from NOW
