#
# Padded and truncated SHA-1.
#
# This classes pads an input of bit length n with a given padding template,
# calculates the SHA-1 hash of the resulting message, and then truncates the
# digest value to the first n bits.
#
# NOTE: This class hasn't been tested for other padding templates than \000 * 40.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'digest/sha1'
require 'digester'

class PTSHA1 < Digester
	
	def self.no_of_bits=(no_of_bits)
		@@no_of_bits = no_of_bits
		@@no_of_bytes = 1 + (@@no_of_bits - 1) / 8
		@@no_of_bitshifts = (8 - @@no_of_bits) % 8
		@@no_of_contrabitshifts = 8 - @@no_of_bitshifts
	end

	def self.padding=(padding)
		@@padding = padding
	end

	def digest(input)
		message = prepare_message(input)
		digest = Digest::SHA1.digest(message) 
		return extract_output(digest)
	end
	
	def prepare_message_byte(input, i)
		if (i + 1 == @@no_of_bytes)
			return input.getbyte(i) << @@no_of_bitshifts
		else 
			return (input.getbyte(i) << @@no_of_bitshifts) + (input.getbyte(i+1) >> @@no_of_contrabitshifts)
		end
	end
	
	def prepare_message(input)
		result = @@padding
		1.upto(@@no_of_bytes) { | i |  result.setbyte(i-1, prepare_message_byte(input, i - 1))}
		return result
	end
	
	def extract_output_byte(digest, i)
		if (i == 0)
			return digest.getbyte(i) >> @@no_of_bitshifts
		else
			return (digest.getbyte(i) >> @@no_of_bitshifts) + (digest.getbyte(i-1) << @@no_of_contrabitshifts)
		end
	end
	
	def extract_output(digest)
		result = "*" * @@no_of_bytes
		1.upto(@@no_of_bytes) { | i | result.setbyte(i-1, extract_output_byte(digest, i - 1))}
		return result
	end
	
	def algorithm_name
		return "PT#{@@no_of_bits}SHA-1"
	end

	def twitter_tag
		return "PT#{@@no_of_bits}SHA1CRK"
	end	

end