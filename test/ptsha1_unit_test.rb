#
# CRK – Cracking cryptographic hash functions using the Web 2.0.
# Copyright © 2011,2014 Filip van Laenen <f.a.vanlaenen@ieee.org>
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
# Unit tests on the PTSHA1 convenience class
#

require 'test/unit'

require 'hex'
require 'ptsha1'

include Hex

class Ptsha1UnitTest < Test::Unit::TestCase
  
  def setup
    PTSHA1.padding = "\0" * 20
    @ptsha1 = PTSHA1.new
  end
  
  # prepare_message
    
  def test_must_prepare_message_for_00_for_5_bits
    PTSHA1.no_of_bits = 5
    assert_equal("00" * 20, hexencode(@ptsha1.prepare_message("\0")))
  end

  def test_must_prepare_message_for_01_for_5_bits
    PTSHA1.no_of_bits = 5
    assert_equal("08" + ("00" * 19), hexencode(@ptsha1.prepare_message("\1")))
  end

  def test_must_prepare_message_for_01_for_8_bits
    PTSHA1.no_of_bits = 8    
    assert_equal("01" + ("00" * 19), hexencode(@ptsha1.prepare_message("\1")))
  end

  def test_must_prepare_message_for_0001_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("0080" + ("00" * 18), hexencode(@ptsha1.prepare_message(hexdecode("0001"))))
  end

  def test_must_prepare_message_for_0080_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("4000" + ("00" * 18), hexencode(@ptsha1.prepare_message(hexdecode("0080"))))
  end

  def test_must_prepare_message_for_0100_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("8000" + ("00" * 18), hexencode(@ptsha1.prepare_message(hexdecode("0100"))))
  end

  def test_must_prepare_message_for_01FF_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("FF80" + ("00" * 18), hexencode(@ptsha1.prepare_message(hexdecode("01FF"))))
  end
  
  # extract_output

  def test_must_extract_output_01_for_5_bits
    PTSHA1.no_of_bits = 5
    assert_equal("01", hexencode(@ptsha1.extract_output(hexdecode("08" + ("00" * 19)))))
  end

  def test_must_extract_output_01_for_8_bits
    PTSHA1.no_of_bits = 8
    assert_equal("01", hexencode(@ptsha1.extract_output(hexdecode("01" + ("00" * 19)))))
  end

  def test_must_extract_output_0001_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("0001", hexencode(@ptsha1.extract_output(hexdecode("0080" + ("00" * 18)))))
  end

  def test_must_extract_output_0080_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("0080", hexencode(@ptsha1.extract_output(hexdecode("4000" + ("00" * 18)))))
  end

  def test_must_extract_output_01FF_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("01FF", hexencode(@ptsha1.extract_output(hexdecode("FF80" + ("00" * 18)))))
  end
  
  # digest

  def test_must_calculate_hash_for_00_for_5_bits
    PTSHA1.no_of_bits = 5
    assert_equal("0C", hexencode(@ptsha1.digest("\0")))
  end

  def test_must_calculate_hash_for_01_for_5_bits
    PTSHA1.no_of_bits = 5
    assert_equal("0D", hexencode(@ptsha1.digest("\1")))
  end

  def test_must_calculate_hash_for_00_for_8_bits
    PTSHA1.no_of_bits = 8
    assert_equal("67", hexencode(@ptsha1.digest("\0")))
  end

  def test_must_calculate_hash_for_01_for_8_bits
    PTSHA1.no_of_bits = 8
    assert_equal("9A", hexencode(@ptsha1.digest("\1")))
  end

  def test_must_calculate_hash_for_0000_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("00CE", hexencode(@ptsha1.digest(hexdecode("0000"))))
  end

  def test_must_calculate_hash_for_0001_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("017F", hexencode(@ptsha1.digest(hexdecode("0001"))))
  end

  def test_must_calculate_hash_for_0080_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("0132", hexencode(@ptsha1.digest(hexdecode("0080"))))
  end

  def test_must_calculate_hash_for_01FF_for_9_bits
    PTSHA1.no_of_bits = 9
    assert_equal("01A4", hexencode(@ptsha1.digest(hexdecode("01FF"))))
  end

  def test_must_calculate_hash_for_00000000_for_32_bits
    PTSHA1.no_of_bits = 32
    assert_equal("6768033E", hexencode(@ptsha1.digest(hexdecode("00000000"))))
  end

  def test_must_calculate_hash_for_FFFFFFFF_for_32_bits
    PTSHA1.no_of_bits = 32
    assert_equal("B35A659A", hexencode(@ptsha1.digest(hexdecode("FFFFFFFF"))))
  end
    
  # segment_twitter_message
  
  def test_segment_twitter_message
    PTSHA1.no_of_bits = 32
    result_start = '00EB9C3D'
    result_result = '00DD04DB'
    result_length = 366
    result = Result.new(result_start, result_result, result_length)
    assert_equal "PT32SHA-1{#{result_length}}(#{result_start}) = #{result_result} #PT32SHA1CRK", @ptsha1.segment_twitter_message(result)
  end  
  
  # colliding_segment_twitter_message
  
  def test_colliding_segments_twitter_message
    PTSHA1.no_of_bits = 32
    result_start1 = '00A176D8'
    result_start2 = '00872A86'
    result_result = '00DD04DB'
    result_length1 = 366
    result_length2 = 4652
    result1 = Result.new(result_start1, result_result, result_length1)
    result2 = Result.new(result_start2, result_result, result_length2)
    assert_equal "PT32SHA-1{#{result_length1}}(#{result_start1}) = PT32SHA-1{#{result_length2}}(#{result_start2}) #PT32SHA1CRK", @ptsha1.colliding_segments_twitter_message(result1, result2)
  end
  
end