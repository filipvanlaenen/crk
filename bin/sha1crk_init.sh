#!/bin/sh
#
# Does the initialization for SHA1CRK
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

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