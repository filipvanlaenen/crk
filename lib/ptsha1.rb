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
# Padded and truncated SHA-1.
#
# This classes pads an input of bit length n with a given padding template,
# calculates the SHA-1 hash of the resulting message, and then truncates the
# digest value to the first n bits.
#
# NOTE: This class hasn't been tested for other padding templates than \000 * 40.
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