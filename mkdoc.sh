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
    pod2text "$i" > "$DST/$( basename $i).txt" \
     && pandoc "$DST/$( basename $i).txt" "$DST/$( basename $i).md" 
done
for i in $( find ./plugin -type f -not -path "./plugin/*enabled" ); do 
    DST="doc/$( dirname $i)"
    [ -d $DST ] || mkdir -p $DST
    pod2html "$i" > "$DST/$( basename $i).html"
    pod2text "$i" > "$DST/$( basename $i).txt" \
     && pandoc "$DST/$( basename $i).txt" "$DST/$( basename $i).md" 
     
done
RES=""

cd doc
cat <<EOF > API.md

# Documentation of each scripts

API of each components.

EOF
for i in $( find . -name "*txt" -a -not -path ".*.git*" -a -not -name "README*" | sort ); do

    echo "## $i" >> API.md
    echo >> API.md 
    cat "$i" >> API.md
    echo >> API.md 
done
cat ../*md API.md > _index.md
pandoc -f gfm --toc -s _index.md -o ../index.md

rm *md
cat ../HEAD_md ../index.md > ./README.md
rm ../index.md 

pandoc README.md -o "index.html"
pandoc README.md    -o FAIM.pdf
