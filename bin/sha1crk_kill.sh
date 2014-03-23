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
# Kills the SHA1CRK client.
#

PIDS=$(ps ux | awk '/sha1crk\.rb/ && !/awk/ {print $2}')
if [ ${#PIDS[@]} -ne "0" ]; then
  echo "SHA1CRK seems to be running. Will try to kill the processes with the following IDs:"
  echo "${PIDS}"
  for PID in $PIDS
  do
        kill $PID
  done
else
  echo "It doesn't look like there's an instance of SHA1CRK running."
fi
