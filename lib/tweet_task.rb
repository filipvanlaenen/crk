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
# A task to tweet a message
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
			Services.log.warn("Exception occured while trying to tweet #{@message}: #{e.message}.")
			return [self]			
		end
		if (success)
			Services.log.info("Tweeted #{@message}.")
			return []
		else
			Services.log.warn("Error occured while trying to tweet #{@message}.")
			return [self]
		end
	end
	
end
