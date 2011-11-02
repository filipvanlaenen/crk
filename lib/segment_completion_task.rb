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
# A calculation task
#

require 'colliding_segments_task'
require 'result'

class SegmentCompletionTask

	attr_reader :result, :distinction_scale
	
	def initialize(result, distinction_scale)
		@result = result
		@distinction_scale = distinction_scale
	end
	
	def self.cache=(cache)
		@@cache = cache
	end

	def ==(other_task)
		return (other_task.instance_of?(SegmentCompletionTask)) && (other_task != nil) && (@result == other_task.result) && (@distinction_scale == other_task.distinction_scale)
	end
	
	def perform
		@@cache.store(@result)
		next_tasks = []
		next_tasks += tasks_to_handle_possible_collision
		next_tasks += next_calculation_task
		return next_tasks
	end

	def tasks_to_handle_possible_collision
		colliding_segment = @@cache.get_colliding_segment(@result)
		if (colliding_segment == nil)
			return []
		else
			Services.log.info("Segment found in cache with end point #{@result.result}, starting with #{colliding_segment.start}; will try to resolve the collision.")
			tweet_task = TweetTask.new(Services.digester.colliding_segments_twitter_message(@result, colliding_segment))
			colliding_segments_task = CollidingSegmentsTask.new(@result, colliding_segment, @distinction_scale)
			return [tweet_task, colliding_segments_task]
		end
	end

	def next_calculation_task
		next_segment_in_path = @@cache.get_next_segment_in_path(@result)
		if (next_segment_in_path == nil)
			Services.log.info("No segment found in cache with end point #{@result.result}; continuing calculations from there.")
			return [CalculationTask.new(@result.result, @result.result, 0, @distinction_scale)]
		else 
			Services.log.info("Segment found in cache with having end point #{@result.result} as starting point; will not continue this path.")
			return []
		end
	end

end