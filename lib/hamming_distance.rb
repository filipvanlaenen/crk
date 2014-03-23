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
# Hamming distance
#

require 'bit_operations_on_strings'

module HammingDistance

  include BitOperationsOnStrings

  def hamming_distance(message1, message2)
    min_length = [message1.length, message2.length].min
    distance = 0
    (0..(min_length - 1)).each do | i |
      distance = distance + hamming_halfbyte_distance(message1, message2, i)
    end
    max_length = [message1.length, message2.length].max
    return distance + 4 * (max_length - min_length)
  end
  
  def hamming_halfbyte_distance(message1, message2, i)
    bits1 = halfbyte_bit_expansion(message1, i)
    bits2 = halfbyte_bit_expansion(message2, i)
    distance = 0
    (0..3).each do | i |
      if (bits1[i] != bits2[i])
        distance = distance + 1
      end
    end
    return distance
  end

end