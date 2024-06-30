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
cp *md doc/

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
cat <<EOF > API.md

Documentation of each scripts
=============================

API of each components.

EOF
for i in $( find . -name "*html" -a -not -path ".*.git*" -a -not -name "README*" | sort ); do
    echo "- [$(dirname $i)/$( basename $i .html )](file:./$i)" >> API.md
done
cat ../*md API.md > _index.md
pandoc -f gfm --toc -s _index.md -o index.md

pandoc index.md -o "index.html"
#for i in $( find . -name "*html" -a -not -path ".*.git*" | sort ); do
#    OUT="$(dirname $i)/$( basename $i .html ).md"
#    pandoc $i -o "$OUT"
#    perl -i -ane 's/\((.*).html\)/\($1.md\)/ and print $_ or print $_'  $OUT 
#done
