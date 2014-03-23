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
# Shows the current status of the SHA1CRK client.
#

LOCALSHA1CRKDIR="${HOME}/.sha1crk"

if [ ! -d "$LOCALSHA1CRKDIR" ]; then
  echo "Local SHA1CRK directory does not exist -- (re)run initialization."
  exit
fi

LOCALSHA1CRKCONFIGFILE="$LOCALSHA1CRKDIR/sha1crk-config.yaml"

if [ ! -e "$LOCALSHA1CRKCONFIGFILE" ]; then
  echo "Local SHA1CRK configuration file does not exist -- (re)run initialization."
  exit
fi

PIDS=$(ps ux | awk '/sha1crk\.rb/ && !/awk/ {print $2}')
if [ ${#PIDS[@]} -ne "0" ]; then
  echo "SHA1CRK seems to be running. Check out the processes with the following IDs for more information:"
  echo "${PIDS}"
else
  echo "It doesn't look like there's an instance of SHA1CRK running."
fi

LOCALSHA1CRKLOGFILE=`cat "$LOCALSHA1CRKCONFIGFILE" | grep log_filename | sed 's/log_filename\:\\s*//'`

echo "This is the last line of SHA1CRK's log file ($LOCALSHA1CRKLOGFILE):"

tail --lines=1 $LOCALSHA1CRKLOGFILE