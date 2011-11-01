#
# Bit operations on string
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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