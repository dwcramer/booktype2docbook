#!/bin/sh

SOURCE_DIR=$1
DEST_DIR=docbook

BOOK_FILE=$DEST_DIR/book.xml

HEROLD=herold/herold/jars/herold.jar
PROFILE=herold/herold/profiles/book.her

mkdir -p $DEST_DIR

cp -r $SOURCE_DIR/static $DEST_DIR/
cp pom.xml $DEST_DIR/

cat > $BOOK_FILE <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<book version="5.0" 
      xml:id="os-security-guide" 
      xmlns:xi="http://www.w3.org/2001/XInclude"
      xmlns="http://docbook.org/ns/docbook" 
      xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>OpenStack Security Guide</title>
    <info>
        <author>
            <personname>
                <firstname/>
                <surname/>
            </personname>
            <affiliation>
                <orgname>OpenStack Foundation</orgname>
            </affiliation>
        </author>
        <copyright>
            <year>2013</year>
            <holder>OpenStack Foundation</holder>
        </copyright>
        <productname>OpenStack</productname>
        <releaseinfo>????, 2013.7</releaseinfo>
        <pubdate/>
        <legalnotice role="apache2">
            <annotation>
                <remark>Copyright details are filled in by the
                    template.</remark>
            </annotation>
        </legalnotice>
        <abstract>
            <para>Ipsum lorem</para>
        </abstract>
        <revhistory>
            <!-- ... continue addding more revisions here as you change this document using the markup shown below... -->
            <revision>
                <date>2013-07-02</date>
                <revdescription>
                    <itemizedlist>
                        <listitem>
                            <para>Initial creation....</para>
                        </listitem>
                    </itemizedlist>
                </revdescription>
            </revision>
        </revhistory>
    </info>
EOF

# Adding "| sort" so chapters will be in correct order
for file in `find $SOURCE_DIR -maxdepth 1 -iname '*.html' -print | sort`;
do
    BASE=`basename $file .html`
    OUTPUT=$DEST_DIR/$BASE.xml
    # I installed herold using apt-get on Ubuntu, so using the wrapper script
    # Also, I'm genrating $OUTPUT.tmp so I can further process the output file.
    # Remove <br>s from source files. These appear in <pre> element for some reason.
    # There's one src attribute on an image that has a full, 
    # but malformed url instead of a relative path. Cleaning that up.
    sed 's/<br>//' $file | sed 's#http:/openstack.booktype.pro/security-guide/_full/###' > $file.tmp
    # java -jar $HEROLD -p $PROFILE -i $file.tmp -o $OUTPUT.tmp
    herold -i $file.tmp -o $OUTPUT.tmp
    rm $file.tmp
    # Now process with an xslt to:
    # 1. Remove <article> wrappers
    # 2. Convert top level <section> to <chapter>
    # 3. Add xml:id attributes to chapter and sections
    xsltproc --stringparam BASE $BASE cleanup.xsl $OUTPUT.tmp > $OUTPUT
    # Cleanup temp file:
    rm $OUTPUT.tmp 
    echo "<xi:include href='${BASE}.xml'/>" >> $BOOK_FILE
done

cat >> $BOOK_FILE <<EOF
</book>
EOF

cd $DEST_DIR
mvn clean generate-sources
cd -
