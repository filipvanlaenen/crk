#
# Hamming distance
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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