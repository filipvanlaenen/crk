#
# Unit tests on CalculcationTask
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'test/unit'

require 'hex'
require 'calculation_task'
require 'dummy_rand_facade'
require 'time'
require 'dummy_time_facade'
require 'tweet_task'

class CalculationTaskUnitTest < Test::Unit::TestCase
	
	include Hex

	TaskStart = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
	TaskCurrentPoint = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
	NextTaskCurrentPoint = '71D9B60D3C8C98C3F499CD7707FD28A2BBE9DB26'
	FirstDistinguishedPointAtScale1 = '00DD04DB1822766918DF18115D3C1D6EAD3E9C9D'
	TaskCurrentLength = 0
	MaxIterationsAllowed = 5
	NextTaskCurrentLength = TaskCurrentLength + MaxIterationsAllowed

	def setup
		@first_task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength)
		@first_task_scale_1 = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength, 1)
		@first_task_scale_3 = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength, 3)
		@first_task_scale_10 = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength, 10)
		@next_task = CalculationTask.new(TaskStart, NextTaskCurrentPoint, NextTaskCurrentLength)
		@next_task_scale_10 = CalculationTask.new(TaskStart, NextTaskCurrentPoint, NextTaskCurrentLength, 10)
		Services.time = TimeFacade.new
		Services.log = LogFacade.new		
	end
	
	def dummy_time
		now = Time.now
		return DummyTimeFacade.new([now, now + 1])
	end

	# ==
	
	def test_identical_is_also_equal
		assert @first_task == @first_task
	end
	
	def test_same_values_is_equal
		new_first_task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength)
		assert @first_task == new_first_task
	end
	
	def test_different_start_is_not_equal
		other_task = CalculationTask.new(NextTaskCurrentPoint, TaskCurrentPoint, TaskCurrentLength)
		assert @first_task != other_task
	end

	def test_different_current_is_not_equal
		other_task = CalculationTask.new(TaskStart, NextTaskCurrentPoint, TaskCurrentLength)
		assert @first_task != other_task
	end

	def test_different_current_length_is_not_equal
		other_task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength + 1)
		assert @first_task != other_task
	end
	
	def test_different_distinction_scale_is_not_equal
		other_task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength, 10)
		assert @first_task != other_task
	end

	def test_default_distinction_scale_is_4
		other_task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength, 4)
		assert @first_task == other_task
	end

	def test_nil_is_not_equal
		assert @first_task != nil
	end
	
	def test_object_of_other_class_is_not_equal
		assert @first_task != Array.new
	end
	
	# distinguished?
		
	def test_string_with_3_leading_0s_is_not_distinguished
		assert(!@first_task.distinguished?(hexdecode('0000000D3C8C98C3F499CD7707FD28A2BBE9DB26')))
	end

	def test_string_with_4_leading_0s_is_distinguished
		assert(@first_task.distinguished?(hexdecode('000000000C8C98C3F499CD7707FD28A2BBE9DB26')))
	end

	def test_string_with_4_trailing_0s_is_not_distinguished
		assert(!@first_task.distinguished?(hexdecode('71D9B60D3C8C98C3F499CD7707FD28A200000000')))
	end
	
	def test_string_with_4_leading_0s_after_newline_is_not_distinguished
		assert(!@first_task.distinguished?(hexdecode('710A0000000098C3F499CD7707FD28A2BBE9DB26')))
	end
	
	def test_string_with_two_leading_0s_is_not_distinguished_when_scale_is_3
		assert(!@first_task_scale_3.distinguished?(hexdecode('0000B60D3C8C98C3F499CD7707FD28A2BBE9DB26')))
	end	

	def test_string_with_three_leading_0s_is_distinguished_when_scale_is_3
		assert(@first_task_scale_3.distinguished?(hexdecode('0000006D3C8C98C3F499CD7707FD28A2BBE9DB26')))
	end	

	# perform: next task
	
	def test_perform_calculation_no_result
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		assert_equal [@next_task_scale_10], @first_task_scale_10.perform
	end
	
	def test_perform_calculation_with_result
		CalculationTask.max_iterations_allowed = 1000
		result = Result.new(TaskStart, FirstDistinguishedPointAtScale1, 366)
		segment_completion_task = SegmentCompletionTask.new(result, 1)
		tweet_task = TweetTask.new(Services.digester.segment_twitter_message(result))
		assert_equal [tweet_task, segment_completion_task], @first_task_scale_1.perform
	end

	# perform: timing
	
	def test_perform_calculation_at_100_percent_cpu_share_requests_no_sleep_time
		Services.time = dummy_time
		CalculationTask.cpu_share = 1
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		@first_task_scale_10.perform
		assert_equal 0, Services.time.requested_sleep_time
	end

	def test_perform_calculation_at_10_percent_cpu_share_requests_90_percent_sleep_time
		Services.time = dummy_time
		CalculationTask.cpu_share = 0.1
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		@first_task_scale_10.perform
		assert_equal 9, Services.time.requested_sleep_time
	end
	
	def test_perform_calculation_with_result_requests_no_sleep_time
		Services.time = dummy_time
		CalculationTask.max_iterations_allowed = 1000
		@first_task_scale_1.perform
		assert_equal nil, Services.time.requested_sleep_time
	end
	
	# perform: logging

	def test_log_perform_first_calculation
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		@first_task_scale_10.perform
		assert_equal "Starting calculations on the segment starting with #{TaskStart}", Services.log.debug_message(0)
	end
	
	def test_log_perform_calculation_no_result
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		@next_task_scale_10.perform
		assert_equal "Continuing calculations on the segment starting with #{TaskStart} at #{NextTaskCurrentPoint}, #{NextTaskCurrentLength} iterations already done", Services.log.debug_message(0)
	end

	def test_log_perform_calculation_with_result
		CalculationTask.max_iterations_allowed = 1000
		@first_task_scale_1.perform
		assert_equal "Found the distinguished point #{FirstDistinguishedPointAtScale1} after 366 iterations for the segment starting with #{TaskStart}", Services.log.info_message(0)
	end

	def test_log_perform_calculation_at_10_percent_cpu_share_requests_90_percent_sleep_time
		Services.time = dummy_time
		CalculationTask.cpu_share = 0.1
		CalculationTask.max_iterations_allowed = MaxIterationsAllowed
		@first_task_scale_10.perform
		assert_equal "Worked for 1.0s; will sleep 9.0s", Services.log.debug_message(1)
	end
	
	# random_new
	
	def random_new(scale, rand_start)
		Services.rand = DummyRandFacade.new(0.5)
		rand_task = CalculationTask.new(rand_start, rand_start, 0, scale)
		assert_equal rand_task, CalculationTask.random_new(scale)
	end
	
	def test_random_new_3
		random_new(3, '000000D54A0C0D4F27FA7ADF23E3C45536E9F37C')
	end

	def test_random_new_4
		random_new(4, '000000004A0C0D4F27FA7ADF23E3C45536E9F37C')
	end
	
end