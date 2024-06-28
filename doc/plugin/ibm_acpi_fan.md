-   [NAME](#NAME)
-   [APPLICABLE SYSTEMS](#APPLICABLE-SYSTEMS)
-   [CONFIGURATION](#CONFIGURATION)
-   [USAGE](#USAGE)
-   [INTERPRETATION](#INTERPRETATION)
-   [MAGIC MARKERS](#MAGIC-MARKERS)
-   [BUGS](#BUGS)
-   [VERSION](#VERSION)
-   [AUTHOR](#AUTHOR)
-   [LICENSE](#LICENSE)

NAME {#NAME}
====

acpi\_ibm - Munin plugin to monitor the fan speed returned by ACPI
probe.

APPLICABLE SYSTEMS {#APPLICABLE-SYSTEMS}
==================

FreeBSD systems with ACPI support. man acpi\_ibm(4)

CONFIGURATION {#CONFIGURATION}
=============

add ibm\_acpi in loader.conf

USAGE {#USAGE}
=====

Link this plugin to @\@CONFDIR@@/plugins/ and restart the munin-node.

INTERPRETATION {#INTERPRETATION}
==============

The plugin shows the fans\' speeds.

MAGIC MARKERS {#MAGIC-MARKERS}
=============

    #%# family=auto
    #%# capabilities=autoconf

BUGS {#BUGS}
====

None known.

VERSION {#VERSION}
=======

v1.1 - 2024-03-24

AUTHOR {#AUTHOR}
======

Julien Tayon (julien\@tayon.net)

LICENSE {#LICENSE}
=======

GPLv2
