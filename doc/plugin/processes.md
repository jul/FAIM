-   [NAME](#NAME)
-   [ABOUT](#ABOUT)
-   [CONFIGURATION](#CONFIGURATION)
-   [AUTHOR](#AUTHOR)
-   [LICENSE](#LICENSE)
-   [MAGIC MARKERS](#MAGIC-MARKERS)

NAME {#NAME}
====

processes - Plugin to monitor processes and process states.

ABOUT {#ABOUT}
=====

This plugin requires munin-server version 1.2.5 or 1.3.3 (or higher).

This plugin is backwards compatible with the old processes-plugins found
on SunOS, Linux and \*BSD (i.e. the history is preserved).

All fields have colours associated with them which reflect the type of
process (sleeping/idle = blue, running = green, stopped/zombie/dead =
red, etc.)

CONFIGURATION {#CONFIGURATION}
=============

No configuration for this plugin.

AUTHOR {#AUTHOR}
======

Copyright (C) 2006 Lars Strand

LICENSE {#LICENSE}
=======

GNU General Public License, version 2

MAGIC MARKERS {#MAGIC-MARKERS}
=============

    #%# family=auto
    #%# capabilities=autoconf
