#
# Convenience class to convert Strings to and from their hexadeciaml representation
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>

require 'digest/sha1'

module Hex

	def hexdecode(hex)
		string = ""
		hex.scan(/[0-9A-F]{2}/).each{ | byte |  string += byte.to_i(16).chr}
		return string
	end
	
	def hexencode(point)
		return Digest.hexencode(point).upcase
	end

end