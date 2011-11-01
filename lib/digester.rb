#
# Digester superclass. The class implements methods to create the correct Twitter messages.
#
# Subclasses must provide the following methods:
#  - twitter_tag
#  - algorithm_name
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class Digester

	def segment_twitter_message(result)
		return "#{algorithm_name}{#{result.length}}(#{result.start}) = #{result.result} ##{twitter_tag}"
	end
	
	def colliding_segments_twitter_message(result1, result2)
		return "#{algorithm_name}{#{result1.length}}(#{result1.start}) = #{algorithm_name}{#{result2.length}}(#{result2.start}) ##{twitter_tag}"
	end
	
	def collision_twitter_message(message1, message2)
		return "#{algorithm_name}(#{message1}) = #{algorithm_name}(#{message2}) ##{twitter_tag}"
	end

end
