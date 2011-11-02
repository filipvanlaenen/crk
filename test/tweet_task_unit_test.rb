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
# Unit tests on TweetTask
#

require 'test/unit'

require 'tweet_task'

ExceptionMessage = 'Name or service not known'

class DisconnectedTwitterFacade
	
	def tweet(message)
		raise ExceptionMessage
	end
		
end

class RefusedTwitterFacade
	
	def tweet(message)
		return false
	end
		
end

class TweetTaskUnitTest < Test::Unit::TestCase
	
	Message = "Foo"
	
	def setup
		@task = TweetTask.new(Message)
		Services.log = LogFacade.new
		Services.twitter = ArrayTwitterFacade.new
	end
	
	# ==
	
	def test_identical_is_also_equal
		assert @task == @task
	end
	
	def test_same_values_is_equal
		other_task = TweetTask.new(Message)
		assert @task == other_task
	end
	
	def test_different_message_is_not_equal
		other_task = TweetTask.new(Message + Message)
		assert @task != other_task
	end
	
	def test_nil_is_not_equal
		assert @task != nil
	end
	
	def test_object_of_other_class_is_not_equal
		assert @task != Array.new
	end
	
	# perform
	
	def test_perform_tweets_message
		@task.perform
		assert_equal Message, Services.twitter.last_tweet
	end
	
	def test_perform_returns_empty_array_if_tweeted_ok
		assert_equal [], @task.perform
	end

	def test_perform_logs_if_tweeted_ok
		@task.perform
		assert_equal "Tweeted #{Message}", Services.log.info_message(0)
	end

	def test_perform_returns_itself_if_tweeted_not_ok
		original_twitter = Services.twitter
		Services.twitter = RefusedTwitterFacade.new
		result = @task.perform
		Services.twitter = original_twitter
		assert_equal [@task], result
	end

	def test_perform_logs_if_tweeted_not_ok
		original_twitter = Services.twitter
		Services.twitter = RefusedTwitterFacade.new
		@task.perform
		Services.twitter = original_twitter
		assert_equal "Error occured while trying to tweet #{Message}", Services.log.warn_message(0)
	end

	def test_perform_returns_itself_if_disconnected
		original_twitter = Services.twitter
		Services.twitter = DisconnectedTwitterFacade.new
		result = @task.perform
		Services.twitter = original_twitter
		assert_equal [@task], result
	end

	def test_perform_logs_if_disconnected
		original_twitter = Services.twitter
		Services.twitter = DisconnectedTwitterFacade.new
		@task.perform
		Services.twitter = original_twitter
		assert_equal "Exception occured while trying to tweet #{Message}: #{ExceptionMessage}", Services.log.warn_message(0)
	end
end