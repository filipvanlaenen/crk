#
# A task to tweet a message
#
# Author: Filip van Laenen
#

class TweetTask
	
	attr_reader :message
	
	def initialize(message)
		@message = message
	end
	
	def ==(other_task)
		return (other_task.instance_of?(TweetTask)) && (other_task != nil) && (@message == other_task.message)
	end
	
	def perform
		begin
			success = Services.twitter.tweet(@message)
		rescue Exception => e
			Services.log.warn("Exception occured while trying to tweet #{@message}: #{e.message}")
			return [self]			
		end
		if (success)
			Services.log.info("Tweeted #{@message}")
			return []
		else
			Services.log.warn("Error occured while trying to tweet #{@message}")
			return [self]
		end
	end
	
end
