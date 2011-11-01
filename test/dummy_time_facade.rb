#
# Dummy time façade
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'time_facade'

class DummyTimeFacade < TimeFacade
	
	attr_reader :requested_sleep_time
	
	def initialize(times)
		@now = times
	end
	
	def now
		return @now.shift
	end
	
	def sleep(seconds)
		@requested_sleep_time = seconds
	end
	
end