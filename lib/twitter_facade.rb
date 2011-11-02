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

require 'oauth'

class TwitterFacade
	
	TwitterServer = "twitter.com"
	
	def initialize
	end
	
	def load_oauth_access_token(oauth_access_token_dump)
		oauth_access_token = Services.io.read(oauth_access_token_dump)
		@access_token = Marshal.load(oauth_access_token)
	end
	
	def tweet(message)
		if (@access_token == nil)
			Services.log.error("Can't tweet messages when there is no OAuth access token available.")
			return false
		end
		res = @access_token.post('/statuses/update.json', {'status'=>message})
		case res
		when Net::HTTPSuccess, Net::HTTPRedirection
			return true
		else
			Services.log.error("Couldn't tweet a message: #{res.body}")
			return false
		end		
	
	end
		
end
