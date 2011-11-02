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
# A task to find the collision from two colliding segments
#

class CollidingSegmentsTask
	
	attr_reader :distinction_scale, :current_calculation_segment, :current_calculation_task
	
	def initialize(result0, result1, distinction_scale)
		@original_result = [result0, result1]
		@remaining_length = [result0.length, result1.length]
		@current_point = [result0.start, result1.start]
		@last_result = [nil, nil]
		@distinction_scale = distinction_scale
		@current_calculation_task = nil
		@current_calculation_segment = nil
	end
	
	def ==(other_task)
		return (other_task.instance_of?(CollidingSegmentsTask)) && (@distinction_scale == other_task.distinction_scale) && (((result(0) == other_task.result(0)) && (result(1) == other_task.result(1))) || ((result(0) == other_task.result(1)) && (result(1) == other_task.result(0))))
	end
	
	def result(i)
		return @original_result[i]
	end
	
	def current_point(i)
		return @current_point[i]
	end
	
	def remaining_length(i)
		return @remaining_length[i]
	end

	def perform
		if (@current_calculation_task == nil)
			@current_calculation_task = pick_new_calculation_task
		end
		calculation_task_result_tasks = @current_calculation_task.perform
		if (contains_result?(calculation_task_result_tasks))
			next_tasks = handle_calculation_task_result(calculation_task_result_tasks)
		else
			next_tasks = prepare_calculation_task_continuation(calculation_task_result_tasks)
		end
		return next_tasks
	end
	
	def pick_new_calculation_task
		if (@remaining_length[0] > @remaining_length[1])
			@current_calculation_segment = 0
		else
			@current_calculation_segment = 1
		end
		new_start_point = @current_point[@current_calculation_segment]
		return CalculationTask.new(new_start_point, new_start_point, 0, @distinction_scale - 1)
	end
	
	def contains_result?(tasks)
		return tasks.any?{ | t | t.instance_of?(SegmentCompletionTask)}
	end
	
	def prepare_calculation_task_continuation(calculation_task_result_tasks)
		@current_calculation_task = calculation_task_result_tasks.select{ | t | t.instance_of?(CalculationTask)}.first
		return [self]
	end

	def handle_calculation_task_result(calculation_task_result_tasks)
		result = calculation_task_result_tasks.select{ | t | t.instance_of?(SegmentCompletionTask)}.first.result
		@last_result[@current_calculation_segment] = result
		@remaining_length[@current_calculation_segment] -= result.length
		@current_point[@current_calculation_segment] = result.result
		@current_calculation_segment = nil
		@current_calculation_task = nil
		if (@current_point[0] == @current_point[1])
			return create_next_tasks(@last_result[0], @last_result[1], @distinction_scale - 1)
		else
			return [self]
		end
	end
	
	def create_next_tasks(result1, result2, new_distinction_scale)
		if (new_distinction_scale == 0)
			tweet_task = TweetTask.new(Services.digester.collision_twitter_message(result1.start, result2.start))
			return [tweet_task]
		else
			tweet_task = TweetTask.new(Services.digester.colliding_segments_twitter_message(result1, result2))
			new_colliding_segments_task = CollidingSegmentsTask.new(result1, result2, new_distinction_scale)	
			return [tweet_task, new_colliding_segments_task]
		end
	end

end
