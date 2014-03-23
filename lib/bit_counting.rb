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
# Bit counting
#

require 'bit_operations_on_strings'

module BitCounting

  include BitOperationsOnStrings
  
  def no_of_ones(message)
    length = message.length
    no_of_ones = 0
    (0..(length - 1)).each do | i |
      bits = halfbyte_bit_expansion(message, i)
      bits.each { | bit | no_of_ones = no_of_ones + bit}
    end
    return no_of_ones
  end

end