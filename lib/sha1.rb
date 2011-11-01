#
# Convenience class for SHA-1
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'digester'
require 'digest/sha1'

class SHA1 < Digester
	
	AlgorithmName = "SHA-1"
	TwitterTag = "SHA1CRK"
	
	def digest(message)
		return Digest::SHA1.digest(message)
	end
	
	def algorithm_name
		return AlgorithmName
	end

	def twitter_tag
		return TwitterTag
	end	

end
