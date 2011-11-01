#
# Unit tests on the calculation of Hamming distances
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'test/unit'

require 'hamming_distance'

class HammingDistanceUnitTest < Test::Unit::TestCase

	include HammingDistance

	Message0 = '00000000'
	Message00 = '000000000'
	Message000 = '0000000000'
	Message1 = '00000001'
	Message2 = '00000002'
	Message3 = '00000003'
	Message33 = '00000033'

	def test_identical_messages_have_distance_zero
		assert_equal 0, hamming_distance(Message0, Message0)
	end
	
	def test_distance_is_one_if_last_bit_is_different
		assert_equal 1, hamming_distance(Message0, Message1)
	end

	def test_distance_is_one_if_one_but_last_bit_is_different
		assert_equal 1, hamming_distance(Message0, Message2)
	end

	def test_distance_is_two_if_last_and_one_but_last_bit_is_different
		assert_equal 2, hamming_distance(Message0, Message3)
	end

	def test_distance_is_four_if_last_and_one_but_last_bits_in_two_bytes_are_different
		assert_equal 4, hamming_distance(Message0, Message33)
	end

	def test_distance_is_four_if_extra_halfbyte
		assert_equal 4, hamming_distance(Message0, Message00)
	end

	def test_distance_is_eight_if_two_extra_halfbytes
		assert_equal 8, hamming_distance(Message0, Message000)
	end
	
	def test_halfbyte_bit_expansionof_0
		assert_equal [0, 0, 0, 0], halfbyte_bit_expansion('0', 0)
	end

	def test_halfbyte_bit_expansionof_F
		assert_equal [1, 1, 1, 1], halfbyte_bit_expansion('F', 0)
	end

end