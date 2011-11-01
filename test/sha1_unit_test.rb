#
# Unit tests on the SHA1 convenience class
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'test/unit'

require 'digester'
require 'result'
require 'sha1'

class Sha1UnitTest < Test::Unit::TestCase
	
	EmptyStringHash = "\3329\243\356^kK\r2U\277\357\225`\030\220\257\330\a\t"
	
	def setup
		@sha1 = SHA1.new
	end
	
	# digest
	
	def test_digests_empty_string
		assert_equal(EmptyStringHash, @sha1.digest(''))		
	end
	
	# segment_twitter_message
	
	def test_segment_twitter_message
		result_start = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
		result_result = '00DD04DB1822766918DF18115D3C1D6EAD3E9C9D'
		result_length = 366
		result = Result.new(result_start, result_result, result_length)
		assert_equal "SHA-1{#{result_length}}(#{result_start}) = #{result_result} #SHA1CRK", @sha1.segment_twitter_message(result)
	end
	
	# colliding_segment_twitter_message
	
	def test_colliding_segments_twitter_message
		result_start1 = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
		result_start2 = '000000000872A8658EF456CD76544ADE54478764'
		result_result = '00DD04DB1822766918DF18115D3C1D6EAD3E9C9D'
		result_length1 = 366
		result_length2 = 4652
		result1 = Result.new(result_start1, result_result, result_length1)
		result2 = Result.new(result_start2, result_result, result_length2)
		assert_equal "SHA-1{#{result_length1}}(#{result_start1}) = SHA-1{#{result_length2}}(#{result_start2}) #SHA1CRK", @sha1.colliding_segments_twitter_message(result1, result2)
	end
	
	# collision_twitter_message
	
	def test_collision_twitter_message
		result_start1 = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
		result_start2 = '000000000872A8658EF456CD76544ADE54478764'
		assert_equal "SHA-1(#{result_start1}) = SHA-1(#{result_start2}) #SHA1CRK", @sha1.collision_twitter_message(result_start1, result_start2)
	end
	
end