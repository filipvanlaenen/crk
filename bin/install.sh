#!/bin/sh
#
# CRK – Cracking cryptographic hash functions using the Web 2.0.
# Copyright © 2011 Filip van Laenen <f.a.vanlaenen@ieee.org>
#
# This file is part of CRK.
#
# CRK is free software: you can redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# CRK is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You can find a copy of the GNU General Public License in /doc/gpl.txt
#

#
# Installs CRK into /opt, and creates a link from /usr/bin to the sha1crk script.
#
# Note: Requires root permissions to create the directory. Use sudo to execute this script.
#

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
chmod a+x "$CRKDIR/sha1crk_kill.sh"
chmod a+x "$CRKDIR/sha1crk_start.sh"
chmod a+x "$CRKDIR/sha1crk_status.sh"
ln -f "$CRKDIR/sha1crk.sh" /usr/bin/sha1crk

LOG4R=$(gem1.9.1 list log4r | awk '/log4r/ {print $1}')
if [ ${#LOG4R[@]} -eq "0" ]; then
  $GEM install -r log4r
fi

TWITTER=$(gem1.9.1 list twitter | awk '/twitter/ {print $1}')
if [ ${#TWITTER[@]} -eq "0" ]; then
  $GEM install -r twitter
fi

apt-get install libnotify-bin