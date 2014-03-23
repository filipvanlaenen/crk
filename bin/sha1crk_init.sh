#!/bin/sh
#
# CRK – Cracking cryptographic hash functions using the Web 2.0.
# Copyright © 2011,2014 Filip van Laenen <f.a.vanlaenen@ieee.org>
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
# Does the initialization for SHA1CRK
#

echo "Initializing SHA1CRK:"

CRKDIR="/opt/crk"
LOCALSHA1CRKDIR="${HOME}/.sha1crk"
RUBY="ruby1.9.1"

if [ -d "$LOCALSHA1CRKDIR" ]; then
  echo "Local SHA1CRK directory already exists."
else
    mkdir "$LOCALSHA1CRKDIR"
  echo "Created a local SHA1CRK directory: $LOCALSHA1CRKDIR"
fi

if [ -d "${LOCALSHA1CRKDIR}/cache" ]; then
  echo "Local SHA1CRK cache directory already exists."
else
    mkdir "${LOCALSHA1CRKDIR}/cache"
  echo "Created a local SHA1CRK directory: $LOCALSHA1CRKDIR/cache"
fi

$RUBY -I "${CRKDIR}/lib" "${CRKDIR}/sha1crk_init.rb" "${LOCALSHA1CRKDIR}" 

echo "Initialization of SHA1CRK done."