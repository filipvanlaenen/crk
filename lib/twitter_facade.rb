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
# Facade for Twitter
#

require 'twitter'

class TwitterFacade
	
	TwitterServer = "twitter.com"
	
	def initialize
		@configured = false
	end

	def configure(oauth_consumer_key, oauth_consumer_secret, oauth_access_token, oauth_access_token_secret)
		Twitter.configure do |config|
			config.consumer_key = oauth_consumer_key
			config.consumer_secret = oauth_consumer_secret
			config.oauth_token = oauth_access_token
			config.oauth_token_secret = oauth_access_token_secret
		end
		@configured = true
	end
		
	def tweet(message)
		if (!@configured)
			Services.log.error("Can't tweet messages when the Twitter client hasn't been configured.")
			return false
		end
		begin
			Twitter.update(message)
			return true
		rescue Exception => e
			Services.log.error("Couldn't tweet a message: #{e.message}.")
			return false
		end
	end
		
end
