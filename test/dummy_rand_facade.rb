#
# Dummy random façade
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class DummyRandFacade

	def initialize(value)
		@value = value
	end

	def rand(max = 0)
		return @value
	end
	
end