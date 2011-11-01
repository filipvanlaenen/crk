#
# Unit tests on CollidingSegmentsTask
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'test/unit'

require 'colliding_segments_task'
require 'result'
require 'services'

class CollidingSegmentsTaskUnitTest < Test::Unit::TestCase

	CommonEndPoint = '00003389C2'
	FirstStartingPoint = '000018CC44'
	FirstSegmentLength = 30611
	FirstSegmentResult = '0012B58D81'
	FirstShortenedSegmentLength = 30272
	SecondStartingPoint = '0000625E68'
	SecondSegmentLength = 28924
	Result1 = Result.new(FirstStartingPoint, CommonEndPoint, FirstSegmentLength)
	Result2 = Result.new(SecondStartingPoint, CommonEndPoint, SecondSegmentLength)
	DistinctionScale = 2
	
	NextCollisionFirstStartingPoint = '00D05ADF42'
	NextCollisionFirstLength = 49
	NextCollisionSecondStartingPoint = '00CE913B1A'
	NextCollisionSecondLength = 93
	NextCollisionCommonEndPoint = '0055E52BAC'
	NextCollisionResult1 = Result.new(NextCollisionFirstStartingPoint, NextCollisionCommonEndPoint, NextCollisionFirstLength)
	NextCollisionResult2 = Result.new(NextCollisionSecondStartingPoint, NextCollisionCommonEndPoint, NextCollisionSecondLength)
	NextCollisionDistinctionScale = 1
	
	FirstCollisionMessage = 'EDF8DB44CD'
	SecondCollisionMessage = '0F446BBA18'

	MaxIterationsAllowed = 10

	OtherPoint = '0000111111'

	def setup
		Services.digester = PTSHA1.new
		PTSHA1.no_of_bits = 40
		PTSHA1.padding = "\0" * 20		
		@a_task = CollidingSegmentsTask.new(Result1, Result2, DistinctionScale)
		Services.log = LogFacade.new
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		CalculationTask.cpu_share = 1
	end

	# ==
	
	def test_identical_is_also_equal
		assert @a_task == @a_task
	end


	def test_nil_is_not_equal
		assert @a_task != nil
	end
	
	def test_object_of_other_class_is_not_equal
		assert @a_task != Array.new
	end
	
	def test_objects_with_same_results_are_equal
		assert @a_task == CollidingSegmentsTask.new(Result1, Result2, DistinctionScale)
	end

	def test_objects_with_equal_results_are_equal
		assert @a_task == CollidingSegmentsTask.new(Result.new(FirstStartingPoint, CommonEndPoint, FirstSegmentLength), Result.new(SecondStartingPoint, CommonEndPoint, SecondSegmentLength), DistinctionScale)
	end

	def test_objects_with_same_results_in_different_order_are_equal
		assert @a_task == CollidingSegmentsTask.new(Result2, Result1, DistinctionScale)
	end
	
	def test_objects_with_different_result_are_not_equal
		assert @a_task != CollidingSegmentsTask.new(Result1, Result.new(OtherPoint, CommonEndPoint, SecondSegmentLength), DistinctionScale)
	end
	
	def test_objects_with_different_distinction_scale_are_not_equal
		assert @a_task != CollidingSegmentsTask.new(Result2, Result1, NextCollisionDistinctionScale)
	end
	
	# perform: single perform

	def test_single_perform_set_current_calculation_segment_to_0
		@a_task.perform
		assert_equal 0, @a_task.current_calculation_segment
	end

	def test_single_perform_set_current_calculation_tasks_length_to_max_iterations_allowed
		@a_task.perform
		assert_equal MaxIterationsAllowed, @a_task.current_calculation_task.length
	end

	def test_single_perform_must_not_move_current_point1
		@a_task.perform
		assert_equal FirstStartingPoint, @a_task.current_point(0)
	end
	
	def test_single_perform_must_not_move_current_point2
		@a_task.perform
		assert_equal SecondStartingPoint, @a_task.current_point(1)
	end

	def test_single_perform_must_not_change_remaining_length1
		@a_task.perform
		assert_equal FirstSegmentLength, @a_task.remaining_length(0)
	end
	
	def test_single_perform_must_not_change_remaining_length2
		@a_task.perform
		assert_equal SecondSegmentLength, @a_task.remaining_length(1)
	end
	
	# perform: perform until result != CalculationTask
	
	def perform_until_result
		@a_task.perform
		while (@a_task.current_calculation_task != nil)
			@a_task.perform
		end
	end
	
	def test_perform_until_result_set_current_calculation_segment_to_nil
		perform_until_result
		assert_nil @a_task.current_calculation_segment
	end

	def test_perform_until_result_must_move_current_point1
		perform_until_result
		assert_equal FirstSegmentResult, @a_task.current_point(0)
	end
	
	def test_perform_until_result_must_not_move_current_point2
		perform_until_result
		assert_equal SecondStartingPoint, @a_task.current_point(1)
	end

	def test_perform_until_result_must_change_remaining_length1
		perform_until_result
		assert_equal FirstShortenedSegmentLength, @a_task.remaining_length(0)
	end
	
	def test_perform_until_result_must_not_change_remaining_length2
		perform_until_result
		assert_equal SecondSegmentLength, @a_task.remaining_length(1)
	end
	
	# perform: perform until collision found

	def perform_until_collision(task)
		next_tasks = task.perform
		while (task.current_point(0) != task.current_point(1))
			next_tasks = task.perform
		end
		return next_tasks
	end

	def test_returns_tweet_task_and_new_colliding_segments_task_when_collision_at_distinction_scale_found
		actual_collision_tasks = perform_until_collision(@a_task)
		expected_tweet_task = TweetTask.new(Services.digester.colliding_segments_twitter_message(NextCollisionResult1, NextCollisionResult2))
		expected_colliding_segments_task = CollidingSegmentsTask.new(NextCollisionResult1, NextCollisionResult2, NextCollisionDistinctionScale)
		assert_equal [expected_tweet_task, expected_colliding_segments_task], actual_collision_tasks
	end

	def test_returns_tweet_task_and_new_colliding_segments_task_when_final_collision_found
		colliding_segments_task = CollidingSegmentsTask.new(NextCollisionResult1, NextCollisionResult2, NextCollisionDistinctionScale)
		final_collision_tasks = perform_until_collision(colliding_segments_task)
		tweet_task = TweetTask.new(Services.digester.collision_twitter_message(FirstCollisionMessage, SecondCollisionMessage))
		assert_equal [tweet_task], final_collision_tasks
	end

end