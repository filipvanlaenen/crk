#
# Façade for time functions
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'time'

class TimeFacade
	
	def now
		return Time.now
	end
	
	def sleep(seconds)
		Kernel.sleep(seconds)
	end
			
end
