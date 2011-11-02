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
# Central point to control SHA1CRK. The script accepts the following arguments:
# - init: To initialize SHA1CRK
# - start: To start SHA1CRK
# - stop: To stop SHA1CRK (nicely)
# - kill: To kill SHA1CRK (the hard way)
# - status: To show the status of SHA1CRK
#

CRKDIR="/opt/crk"
ACTION="$1"

case "$ACTION" in
  init)
    ${CRKDIR}/sha1crk_init.sh
    ;;
  start)
    ${CRKDIR}/sha1crk_start.sh
    ;;
  stop)
    echo "Stopping SHA1CRK not implemented yet."
    ;;
  kill)
    echo "Killing SHA1CRK not implemented yet."
    ;;
  status)
    ${CRKDIR}/sha1crk_status.sh
    ;;
  version)
    echo "Version of SHA1CRK not implemented yet."
    ;;    
  *)
    echo "Usage: sha1crk {init|start|stop|kill|status|version}" >&2
    exit 1
    ;;
esac

