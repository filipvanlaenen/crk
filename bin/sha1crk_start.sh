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
# Starts to run SHA1CRK
#

CRKDIR="/opt/crk"
LOCALSHA1CRKDIR="${HOME}/.sha1crk"
RUBY="ruby1.9.1"

if [ ! -d "$LOCALSHA1CRKDIR" ]; then
	echo "Local SHA1CRK directory does not exist -- (re)run initialization before trying to run SHA1CRK."
	exit
fi

if [ ! -e "$LOCALSHA1CRKDIR/sha1crk-config.yaml" ]; then
	echo "Local SHA1CRK configuration file does not exist -- (re)run initialization before trying to run SHA1CRK."
	exit
fi

if [ ! -d "$LOCALSHA1CRKDIR/cache" ]; then
	echo "Local SHA1CRK cache directory does not exist -- (re)run initialization before trying to run SHA1CRK."
	exit
fi

PIDS=$(ps ux | awk '/sha1crk\.rb/ && !/awk/ {print $2}')
if [ ${#PIDS[@]} -ne "0" ]; then
	echo "Apparently, there's already at least one instance of SHA1CRK running."
	echo "Check the processes with the following IDs before trying to start SHA1CRK again:"
	echo "${PIDS}"
	exit
fi

$RUBY -I "${CRKDIR}/lib" "${CRKDIR}/sha1crk.rb" "${LOCALSHA1CRKDIR}" &

notify-send "SHA1CRK" "Started SHA1CRK." -i "${CRKDIR}/png/SHA-1.png" -t 3000
echo "Started SHA1CRK."