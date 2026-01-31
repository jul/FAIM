#!/usr/bin/env bash
<< =cut

=head1 NAME

mkdoc.sh

=head2 SYNOPSIS

Generates the doc. Requires pandoc for markdown to html conversion

    ./mkdoc.sh

=cut

rm README.md
rm doc -rf
[ -d doc ] || mkdir -p doc/img
cp img/* doc/img/
cp *md doc/

for i in $( find . \( -path "./bin/*" -o -path "./plugin/*" \) -type f -not -path "./plugin/*enabled" -not -path "./bin/*py" ); do 
    DST="doc/$( dirname $i )"
    [ -d $DST ] || mkdir -p $DST
    pod2html --noindex "$i" > "$DST/$( basename $i).html"
    pandoc --shift-heading-level-by=2 --toc-depth=1 --to markdown "$DST/$( basename $i).html" -o "$DST/$( basename $i).txt" 
     
done
RES=""

cd doc
echo > API.md
cat <<EOF > API.md

# Documentation of each scripts

API of each components.

EOF
for i in $( find . -name "*txt" | sort | grep -v .git ); do
    echo >> API.md 
    echo "## $i" >> API.md
    echo >> API.md 
    cat "$i" >> API.md
    echo >> API.md 
done
cat ../*md API.md > _index.md
pandoc -f gfm --toc --toc-depth=2  -s _index.md -o ../index.md

rm *md
cat ../HEAD_md ../index.md > ./README.md
rm ../index.md 

cat ./README.md > ../README.md

pandoc README.md -T "FAIM documentation" --embed-resources -o "index.html"
pandoc README.md    -o FAIM.pdf
