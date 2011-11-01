#
# Class implementing the Twitter facade, but storing the messages in an Array.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class ArrayTwitterFacade
	
	def initialize
		@tweets = []
	end
	
	def tweet(message)
		@tweets << message
		return true
	end
	
	def last_tweet
		return @tweets.last
	end
	
end
