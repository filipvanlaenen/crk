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
# Unit tests on Result
#

require 'test/unit'

require 'result'

class ResultUnitTest < Test::Unit::TestCase
  
  PartialResultStart = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
  PartialResultResult =  '000000004A6D489E543035011BB6463AF7F34EB1'
  OtherDistinguishedPoint =  '000000008295789E543035011BB6463AF7F34EB1'
  PartialResultLength = 1839701147
  PartialResult = Result.new(PartialResultStart, PartialResultResult, PartialResultLength)
  PartialResultCacheLine = "#{PartialResultStart}.#{PartialResultResult}.#{PartialResultLength}"

  # ==
  
  def test_identical_is_also_equal
    assert PartialResult == PartialResult
  end

  def test_same_values_is_equal
    other_result = Result.new(PartialResultStart, PartialResultResult, PartialResultLength)
    assert PartialResult == other_result
  end
  
  def test_different_start_is_not_equal
    other_result = Result.new(OtherDistinguishedPoint, PartialResultResult, PartialResultLength)
    assert PartialResult != other_result
  end

  def test_different_end_is_not_equal
    other_result = Result.new(PartialResultStart, OtherDistinguishedPoint, PartialResultLength)
    assert PartialResult != other_result
  end

  def test_different_current_length_is_not_equal
    other_task = Result.new(PartialResultStart, PartialResultResult, PartialResultLength + 1)
    assert PartialResult != other_task
  end
  
  def test_nil_is_not_equal
    assert PartialResult != nil
  end
  
  def test_object_of_other_class_is_not_equal
    assert PartialResult != Array.new
  end  

  # cache_filename
  
  def test_cache_filename
    assert_equal "000000000A-000000004.txt", PartialResult.cache_filename
  end

  # cache_line

  def test_cache_line
    assert_equal PartialResultCacheLine, PartialResult.cache_line
  end
  
  # collision_files_pattern
  
  def test_collision_files_pattern
    assert_equal '*-000000004.txt', PartialResult.collision_files_pattern
  end
  
  # next_segment_in_path_files_pattern
  
  def test_next_segment_in_path_files_pattern
    assert_equal '000000004-*.txt', PartialResult.next_segment_in_path_files_pattern
  end

  # collision_pattern

  def test_collision_pattern
    assert_equal /.*\.#{PartialResultResult}\..*/, PartialResult.collision_pattern
  end

  # next_segment_in_path_pattern

  def test_next_segment_in_path_pattern
    assert_equal /^#{PartialResultResult}\..*\..*/, PartialResult.next_segment_in_path_pattern
  end

  # from_line
  
  def test_instantiate_from_line
    assert_equal PartialResult, Result.from_line(PartialResultCacheLine)
  end
  
end
