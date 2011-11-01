#
# Unit tests on SegmentCompletionTask
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'test/unit'

require 'segment_completion_task'
require 'colliding_segments_task'
require 'result'
require 'tweet_task'

class SegmentCompletionTaskUnitTest < Test::Unit::TestCase

	TaskStart = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
	TaskEnd = '000000001822766918DF18115D3C1D6EAD3E9C9D'	
	OtherDistinguishedPoint = '000000003952766918DF18115D3C1D6EAD3E9C9D'	
	AnotherDistinguishedPoint = '000000009853986528DF18115D3C1D6EAD3E9C9D'
	DistinctionScale = 4	
	TaskLength = 366
	
	def setup
		Services.io = DummyIoFacade.new
		Services.log = LogFacade.new		
		@cache = Cache.new('')
		SegmentCompletionTask.cache = @cache		
		@task_result = Result.new(TaskStart, TaskEnd, TaskLength)
		@a_task = SegmentCompletionTask.new(@task_result, DistinctionScale)
	end
	
	# ==
	
	def test_identical_is_also_equal
		assert @a_task == @a_task
	end

	def test_same_result_is_equal
		other_task = SegmentCompletionTask.new(Result.new(TaskStart, TaskEnd, TaskLength), DistinctionScale)
		assert @a_task == other_task
	end
		
	def test_different_result_is_not_equal
		other_task = SegmentCompletionTask.new(Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength), DistinctionScale)
		assert @a_task != other_task
	end

	def test_different_distinction_scale_is_not_equal
		other_task = SegmentCompletionTask.new(@task_result, DistinctionScale - 1)
		assert @a_task != other_task
	end

	def test_nil_is_not_equal
		assert @a_task != nil
	end
	
	def test_object_of_other_class_is_not_equal
		assert @a_task != Array.new
	end
	
	# perform: next tasks
	
	def test_saves_when_segment_absent_from_cache
		@a_task.perform
		assert @cache.include?(@task_result)
	end

	def test_saves_segment_when_other_segment_with_same_end_has_different_start
		other_result = Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength)
		@cache.store(other_result)
		@a_task.perform
		assert @cache.include?(@task_result)
	end

	def test_creates_new_calculation_task_when_segment_starting_with_last_result_absent_from_cache
		next_task = CalculationTask.new(TaskEnd, TaskEnd, 0)
		assert_equal [next_task], @a_task.perform
	end


	def test_creates_new_calculation_task_at_correct_distinction_scale_when_segment_starting_with_last_result_absent_from_cache
		task = SegmentCompletionTask.new(@task_result, 3)
		next_task = CalculationTask.new(TaskEnd, TaskEnd, 0, 3)
		assert_equal [next_task], task.perform
	end

	def test_creates_no_new_calculation_task_when_segment_starting_with_last_result_present_in_cache
		other_result = Result.new(TaskEnd, OtherDistinguishedPoint, TaskLength)
		@cache.store(other_result)
		assert_equal [], @a_task.perform
	end

	def test_adds_tasks_to_tweet_and_check_for_collision_when_other_segment_has_different_start
		other_result = Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength * 2)
		@cache.store(other_result)
		next_calculation_task = CalculationTask.new(TaskEnd, TaskEnd, 0)
		verify_collision_task = CollidingSegmentsTask.new(@task_result, other_result, DistinctionScale)
		tweet_possible_collision_task = TweetTask.new(Services.digester.colliding_segments_twitter_message(@task_result, other_result))
		assert_equal [tweet_possible_collision_task, verify_collision_task, next_calculation_task], @a_task.perform
	end
	
	def test_adds_tasks_to_tweet_and_check_for_collision_only_when_both_collision_and_next_segment_on_path_in_cache
		other_result = Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength * 2)
		@cache.store(other_result)
		next_segment_on_path = Result.new(TaskEnd, AnotherDistinguishedPoint, TaskLength * 3)
		@cache.store(next_segment_on_path)
		verify_collision_task = CollidingSegmentsTask.new(@task_result, other_result, DistinctionScale)
		tweet_possible_collision_task = TweetTask.new(Services.digester.colliding_segments_twitter_message(@task_result, other_result))
		assert_equal [tweet_possible_collision_task, verify_collision_task], @a_task.perform
	end

	# perform: logging

	def test_logs_when_no_collision_found
		@a_task.perform
		assert_equal "No segment found in cache with end point #{TaskEnd}; continuing calculations from there", Services.log.info_message(0)
	end

	def test_logs_when_a_collision_found
		other_result = Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength)
		@cache.store(other_result)
		@a_task.perform
		assert_equal "Segment found in cache with end point #{TaskEnd}, starting with #{OtherDistinguishedPoint}; will try to resolve the collision", Services.log.info_message(0)
	end

	def test_logs_when_segment_starting_with_last_result_present_in_cache
		other_result = Result.new(TaskEnd, OtherDistinguishedPoint, TaskLength)
		@cache.store(other_result)
		@a_task.perform
		assert_equal "Segment found in cache with having end point #{TaskEnd} as starting point; will not continue this path", Services.log.info_message(0)
	end

	def test_logs_when_segment_starting_with_last_result_present_in_cache_also_if_collision_found
		other_result = Result.new(OtherDistinguishedPoint, TaskEnd, TaskLength * 2)
		@cache.store(other_result)
		next_segment_on_path = Result.new(TaskEnd, AnotherDistinguishedPoint, TaskLength * 3)
		@cache.store(next_segment_on_path)
		@a_task.perform
		assert_equal "Segment found in cache with having end point #{TaskEnd} as starting point; will not continue this path", Services.log.info_message(1)
	end

end
