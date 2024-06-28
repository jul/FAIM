#!/usr/bin/env bash
<< =cut

=head1 NAME

mkdoc.sh

=head2 SYNOPSIS

Generates the doc. Requires pandoc for markdown to html conversion

    ./mkdoc.sh

=cut

rm doc -rf
[ -d doc ] || mkdir -p doc/img
cp img/* doc/img/

for i in $( find . -name "*sh" ); do 
    DST="doc/$( dirname $i)"
    [ -d $DST ] || mkdir -p $DST
    pod2html --htmlroot=doc --htmldir=doc "$i" > "$DST/$(basename $i).html"
done
for i in $( find ./plugin -type f -not -path "./plugin/*enabled" ); do 
    DST="doc/$( dirname $i)"
    [ -d $DST ] || mkdir -p $DST
    pod2html "$i" > "$DST/$( basename $i).html"
done
RES=""
cd doc
pandoc ../README.md -o index.html
echo "<ul>" >> index.html

for i in $( find . -name "*html" -a -not -path ".*.git*" | sort ); do
    echo "<li><a href=$i > $(dirname $i)/$( basename $i .html )</a></li>" >> index.html ;
done
echo "</ul>" >> index.html
for i in $( find . -name "*html" -a -not -path ".*.git*" | sort ); do
    OUT="$(dirname $i)/$( basename $i .html ).md"
    pandoc $i -o "$OUT"
    perl -i -ane 's/\((.*).html\)/\($1.md\)/ and print $_ or print $_'  $OUT 
done
