#
# CRK – Cracking cryptographic hash functions using the Web 2.0.
# Copyright © 2011,2014 Filip van Laenen <f.a.vanlaenen@ieee.org>
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
# Convenience class for SHA-1
#

require 'digester'
require 'digest/sha1'

class SHA1 < Digester
  
  AlgorithmName = "SHA-1"
  TwitterTag = "SHA1CRK"
  
  def digest(message)
    return Digest::SHA1.digest(message)
  end
  
  def algorithm_name
    return AlgorithmName
  end

  def twitter_tag
    return TwitterTag
  end  

end
