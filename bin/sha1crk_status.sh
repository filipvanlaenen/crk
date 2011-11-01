#!/bin/sh
#
# Shows the current status of the SHA1CRK client.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

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