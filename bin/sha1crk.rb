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
# Runs CRK with SHA-1
#

require 'crk'
require 'twitter_facade'

Services.twitter = TwitterFacade.new

local_sha1crk_dir = File.expand_path(ARGV[0])

sha1crk = Crk.new(File.join(local_sha1crk_dir, 'sha1crk-config.yaml'))

sha1crk.continue