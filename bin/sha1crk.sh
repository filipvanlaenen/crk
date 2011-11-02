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
# Central point to control SHA1CRK.
#

CRKDIR="/opt/crk"
ACTION="$1"
VERSION="0.3a"
COPYRIGHTYEAR="2011"

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
  help)
    echo "CRK (Cracking cryptographic hash functions using the Web 2.0) v${VERSION}"
    echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
    echo
    echo "Usage:"
    echo "  sha1crk action [parameters]"
    echo
    echo "where actions and parameters include:"
    echo "  init        initialize sha1crk"
    echo "  start       start sha1crk"
    echo "  stop        (Not implemented yet)"
    echo "  kill        (Not implemented yet)"
    echo "  status      show status for sha1crk"
    echo "  help        show this message"
    echo "  version     show the version information"
    echo "  copyright   show the copyright information"
    echo "  warranty    show the warranty information"
    ;;
  version)
    echo "CRK (Cracking cryptographic hash functions using the Web 2.0) v${VERSION}"
    echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
    echo "This program comes with ABSOLUTELY NO WARRANTY; for details run 'sha1crk warranty'."
    echo "This is free software, and you are welcome to redistribute it"
    echo "under certain conditions; run 'sha1crk copyright' for details."
    ;;
  copyright)
    echo "CRK (Cracking cryptographic hash functions using the Web 2.0) v${VERSION}"
    echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
    echo
    echo "This program is free software: you can redistribute it and/or modify"
    echo "it under the terms of the GNU General Public License as published by"
    echo "the Free Software Foundation, either version 3 of the License, or"
    echo "(at your option) any later version."
    echo
    echo "This program is distributed in the hope that it will be useful,"
    echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
    echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
    echo "GNU General Public License for more details."
    echo
    echo "You should have received a copy of the GNU General Public License"
    echo "along with this program.  If not, see <http://www.gnu.org/licenses/>."
    ;;
  warranty)
    echo "CRK (Cracking cryptographic hash functions using the Web 2.0) v${VERSION}"
    echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
    echo
    echo "There is no warranty for the program, to the extent permitted by applicable law."
    echo "Except when otherwise stated in writing the copyright holders and/or other"
    echo "parties provide the program “as is” without warranty of any kind, either"
    echo "expressed or implied, including, but not limited to, the implied warranties of"
    echo "merchantability and fitness for a particular purpose. The entire risk as to the"
    echo "quality and performance of the program is with you. Should the program prove"
    echo "defective, you assume the cost of all necessary servicing, repair or correction."
    ;;
  *)
    echo "CRK (Cracking cryptographic hash functions using the Web 2.0) v${VERSION}"
    echo "Copyright © ${COPYRIGHTYEAR} Filip van Laenen <f.a.vanlaenen@ieee.org>"
    echo
    echo "Usage: sha1crk {init|start|stop|kill|status|help|version|warranty|copyright}" >&2
    echo "Type 'sha1crk help' to get more information."
    exit 1
    ;;
esac

