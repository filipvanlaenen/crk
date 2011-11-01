#!/bin/sh
#
# Central point to control SHA1CRK. The script accepts the following arguments:
# - init: To initialize SHA1CRK
# - start: To start SHA1CRK
# - stop: To stop SHA1CRK (nicely)
# - kill: To kill SHA1CRK (the hard way)
# - status: To show the status of SHA1CRK
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

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

