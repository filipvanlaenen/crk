#
# Facade for Twitter
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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
