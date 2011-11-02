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
# Unit tests on the couting of bits in a message
#

require 'test/unit'

require 'bit_counting'

class BitCountingUnitTest < Test::Unit::TestCase

	include BitCounting
	
	Message0 = '00000000'
	Message1 = '11111111'
	MessageF = 'FFFFFFFF'
	
	ShortMessage0 = '00'
	
	def test_no_ones_in_message0
		assert_equal 0, no_of_ones(Message0)
	end	

	def test_no_ones_in_message1
		assert_equal 8, no_of_ones(Message1)
	end	
	
	def test_no_ones_in_messageF
		assert_equal 32, no_of_ones(MessageF)
	end
		
end