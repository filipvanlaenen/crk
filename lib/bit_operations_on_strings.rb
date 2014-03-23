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
# Bit operations on string
#

module BitOperationsOnStrings

  def halfbyte_bit_expansion(string, pos)
    bits = []
    halfbyte_value = string[pos, 1].to_i(16)
    (0..3).each do | i |
      power = 2 ** (3-i)
      if (halfbyte_value >= power)
        bits << 1
        halfbyte_value = halfbyte_value - power
      else
        bits << 0
      end
    end
    return bits
  end

  def bit_expansion(message)
    expansion = []
    (0..(message.length - 1)).each do | i |
      expansion = expansion + halfbyte_bit_expansion(message, i)
    end
    return expansion
  end
  
end