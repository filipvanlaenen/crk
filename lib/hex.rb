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
# Convenience class to convert Strings to and from their hexadeciaml representation
#

require 'digest/sha1'

module Hex

  def hexdecode(hex)
    string = ""
    hex.scan(/[0-9A-F]{2}/).each{ | byte |  string += byte.to_i(16).chr}
    return string
  end
  
  def hexencode(point)
    return Digest.hexencode(point).upcase
  end

end