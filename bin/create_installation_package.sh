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
# Creates an installation package.
#

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