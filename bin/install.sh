#!/bin/sh
#
# Installs CRK into /opt, and creates a link from /usr/bin to the sha1crk script.
#
# Note: Requires root permissions to create the directory. Use sudo to execute this script.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

CRKDIR="/opt/crk"
GEM="gem1.9.1"

if [ -d "$CRKDIR" ]; then
    rm -R "$CRKDIR"
fi

mkdir "$CRKDIR"
mkdir "$CRKDIR/lib"
mkdir "$CRKDIR/png"

cp lib/*.rb "$CRKDIR/lib"
cp png/*.png "$CRKDIR/png"

cp sha1crk* "$CRKDIR"
chmod a+x "$CRKDIR/sha1crk.sh"
chmod a+x "$CRKDIR/sha1crk_init.sh"
chmod a+x "$CRKDIR/sha1crk_start.sh"
chmod a+x "$CRKDIR/sha1crk_status.sh"
ln -f "$CRKDIR/sha1crk.sh" /usr/bin/sha1crk

LOG4R=$(gem1.9.1 list log4r | awk '/log4r/ {print $1}')
if [ ${#LOG4R[@]} -eq "0" ]; then
	$GEM install -r log4r
fi

OAUTH=$(gem1.9.1 list oauth | awk '/oauth/ {print $1}')
if [ ${#OAUTH[@]} -eq "0" ]; then
	$GEM install -r oauth
fi

apt-get install libnotify-bin