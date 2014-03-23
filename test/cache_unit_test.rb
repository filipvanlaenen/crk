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
# Unit tests on the cache
#

require 'test/unit'

require 'cache'
require 'dummy_io_facade'
require 'result'

class CacheUnitTest < Test::Unit::TestCase

  PartialResultStart = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
  PartialResultResult =  '000000004A6D489E543035011BB6463AF7F34EB1'
  OtherDistinguishedPoint = '0000000053945874393035011BB6463AF7F34EB1'
  PartialResultLength = 1839701147
  PartialResult = Result.new(PartialResultStart, PartialResultResult, PartialResultLength)
  PartialResultLine = "#{PartialResultStart}.#{PartialResultResult}.#{PartialResultLength}"
  
  def setup
    Services.io = DummyIoFacade.new
    @cache = Cache.new('')
  end
  
  # store
  
  def test_must_store_result_in_local_cache_file
    @cache.store(PartialResult)
    assert_equal PartialResult.cache_line, Services.io.get('/000000000A-000000004.txt')
  end
  
  # include?

  def test_must_not_include_result_when_not_stored
    assert !@cache.include?(PartialResult)
  end

  def test_must_include_result_after_being_stored
    @cache.store(PartialResult)
    assert @cache.include?(PartialResult)
  end
  
  def test_does_not_include_when_result_with_different_start_stored
    @cache.store(Result.new(OtherDistinguishedPoint, PartialResultResult, PartialResultLength))
    assert !@cache.include?(PartialResult)
  end
  
  def test_does_not_include_when_result_with_different_end_stored
    @cache.store(Result.new(PartialResultStart, OtherDistinguishedPoint, PartialResultLength))
    assert !@cache.include?(PartialResult)
  end

  def test_does_not_include_when_result_with_different_length_stored
    @cache.store(Result.new(PartialResultStart, PartialResultResult, PartialResultLength + 1))
    assert !@cache.include?(PartialResult)
  end
  
  # get_colliding_segment
  
  def test_no_colliding_segment_when_cache_empty
    assert_nil @cache.get_colliding_segment(PartialResult)
  end
  
  def test_no_colliding_segment_when_other_segment_has_different_end_point
    @cache.store(Result.new(PartialResultStart, OtherDistinguishedPoint, PartialResultLength))
    assert_nil @cache.get_colliding_segment(PartialResult)
  end
  
  def test_no_colliding_segment_when_other_segment_has_same_starting_and_end_point
    # Just in case the result was already stored before
    @cache.store(PartialResult)
    assert_nil @cache.get_colliding_segment(PartialResult)
  end

  def test_returns_colliding_segment_when_other_segment_has_same_end_point_but_different_start_point
    colliding_segment = Result.new(OtherDistinguishedPoint, PartialResultResult, PartialResultLength)
    @cache.store(colliding_segment)
    assert_equal colliding_segment, @cache.get_colliding_segment(PartialResult)
  end
  
  # get_next_segment_in_path
  
  def test_no_next_segment_in_path_when_cache_empty
    assert_nil @cache.get_next_segment_in_path(PartialResult)
  end

  def test_no_next_segment_in_path_when_other_segment_has_different_starting_point
    @cache.store(Result.new(OtherDistinguishedPoint, PartialResultStart, PartialResultLength))
    assert_nil @cache.get_next_segment_in_path(PartialResult)
  end

  def test_returns_next_segment_in_path_when_other_segment_has_same_starting_point
    next_segment_in_path = Result.new(PartialResultResult, OtherDistinguishedPoint, PartialResultLength)
    @cache.store(next_segment_in_path)
    assert_equal next_segment_in_path, @cache.get_next_segment_in_path(PartialResult)
  end

end
