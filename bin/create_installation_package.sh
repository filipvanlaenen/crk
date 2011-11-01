#!/bin/sh
#
# Creates an installation package.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

# Create an empty temporary directory

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"
VERSION="0-3a"
TEMPDIR="crk-${VERSION}"

if [ -d "$TEMPDIR" ]; then
    rm -R "$TEMPDIR"
fi

mkdir "$TEMPDIR"

# Copy all resources to the temporary directory

BINDIR=${SCRIPTDIR}/../bin
cp ${BINDIR}/install.sh "$TEMPDIR"
cp ${BINDIR}/sha1crk.rb "$TEMPDIR"
cp ${BINDIR}/sha1crk.sh "$TEMPDIR"
cp ${BINDIR}/sha1crk_init.rb "$TEMPDIR"
cp ${BINDIR}/sha1crk_init.sh "$TEMPDIR"
cp ${BINDIR}/sha1crk_start.sh "$TEMPDIR"
cp ${BINDIR}/sha1crk_status.sh "$TEMPDIR"

DOCDIR=${SCRIPTDIR}/../doc
cp ${DOCDIR}/readme.txt "$TEMPDIR"

LIBDIR=${SCRIPTDIR}/../lib
mkdir "${TEMPDIR}/lib"
cp ${LIBDIR}/*.rb "${TEMPDIR}/lib"

PNGDIR=${SCRIPTDIR}/../png
mkdir "${TEMPDIR}/png"
cp ${PNGDIR}/*.png "${TEMPDIR}/png"

# Creates the archive file

TARFILE="crk-${VERSION}.tar.gz"
tar -pczf $TARFILE "$TEMPDIR"

# Remove the temporary directory

rm -R $TEMPDIR