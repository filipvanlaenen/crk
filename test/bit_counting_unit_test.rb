#
# Unit tests on the couting of bits in a message
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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