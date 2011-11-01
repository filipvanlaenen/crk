#
# Bit counting
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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