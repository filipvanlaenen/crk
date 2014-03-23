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
# A calculation task
#

require 'hex'
require 'segment_completion_task'
require 'result'
require 'tweet_task'

include Hex

class CalculationTask
  
  DefaultDistinctionScale = 4
  
  @@cpu_share = 1
  
  attr_reader :current, :length, :start, :distinction_scale
  
  def initialize(start, current, length, distinction_scale = DefaultDistinctionScale)
    @start = start
    @current = current
    @length = length
    set_distinction_scale_and_string(distinction_scale)
    # Caches the digester locally, in order to safe a reference to another object, so that run_iterations may run a bit faster.
    @digester = Services.digester
  end

  def distinction_scale=(distinction_scale)
    set_distinction_scale_and_string(distinction_scale)
  end
  
  def set_distinction_scale_and_string(distinction_scale)
    @distinction_scale = distinction_scale
    @distinction_string = distinction_string
  end

  def distinction_string
    return "\0" * distinction_scale
  end

  def self.max_iterations_allowed=(max_iterations_allowed)
    @@max_iterations_allowed = max_iterations_allowed
  end
  
  def self.cpu_share=(cpu_share)
    @@cpu_share = cpu_share
  end
  
  def self.random_new(distinction_scale)
    random_start = hexencode(Services.digester.digest(Services.rand.rand.to_s))
    random_start[0, 2 * distinction_scale] = "00" * distinction_scale
    return CalculationTask.new(random_start, random_start, 0, distinction_scale)
  end

  def ==(other_task)
    return (other_task.instance_of?(CalculationTask)) && (other_task != nil) && (@start == other_task.start) && (@current == other_task.current) && (@length == other_task.length) && (@distinction_scale == other_task.distinction_scale)
  end
  
  def distinguished?(string)
      return string.start_with?("\0" * distinction_scale)
  end
  
  def run_iterations
    binary_current = hexdecode(@current)
    iterations_done = 0
    begin
      binary_current = @digester.digest(binary_current)
      @length = @length + 1
      iterations_done = iterations_done + 1
    end until (iterations_done >= @@max_iterations_allowed || distinguished?(binary_current))
    @current = hexencode(binary_current)
    return distinguished?(binary_current)
  end
  
  def perform
    if (@length == 0)
      Services.log.debug "Starting calculations on the segment starting with #{@start}."
    else
      Services.log.debug "Continuing calculations on the segment starting with #{@start} at #{@current}, #{@length} iterations already done."
    end
    before = Services.time.now
    current_distinguished = run_iterations
    after = Services.time.now
    if (current_distinguished)
      Services.log.info "Found the distinguished point #{@current} after #{@length} iterations for the segment starting with #{@start}."
      return create_tasks_for_new_distinguished_point
    else
      sleep_to_compensate_cpu_time(after - before)
      return create_tasks_to_continue_iteration
    end
  end
  
  def sleep_to_compensate_cpu_time(time_used)
    sleeping_time = time_used * ((1 / @@cpu_share) - 1)
    Services.log.debug("Worked for #{time_used}s; will sleep #{sleeping_time}s.")
    Services.time.sleep(sleeping_time)
  end
  
  def create_tasks_to_continue_iteration
    return [CalculationTask.new(@start, @current, @length, @distinction_scale)]
  end
  
  def create_tasks_for_new_distinguished_point
    result = Result.new(@start, @current, @length)
    return [TweetTask.new(Services.digester.segment_twitter_message(result)), SegmentCompletionTask.new(result, @distinction_scale)]
  end
  
end
