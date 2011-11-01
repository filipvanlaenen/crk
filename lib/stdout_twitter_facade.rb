#
# Class implementing the Twitter façade, but printing to stdout instead of posting to Twitter.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class StdoutTwitterFacade
	
	AnsiBoldOn = "\033[1m"
	AnsiBoldOff = "\033[22m"
	AnsiReverseOn = "\033[7m"
	AnsiReverseOff = "\033[27m"
	
	def initialize
		@start_time = Services.time.now
	end
		
	def tweet(message)
		seconds_since_start = Services.time.now - @start_time
		minutes_since_start = (seconds_since_start / 60).to_i
		seconds_since_start = seconds_since_start - 60 * minutes_since_start
		line = ("%3d" % minutes_since_start) + ":" + ("%04.1f" % seconds_since_start) + "  " + message
		if (message =~ /\{.*\}.*\{.*\}/)
			line = AnsiBoldOn + line + AnsiBoldOff
		elsif (message =~ /\(.*\).*\(.*\)/)
			line = AnsiReverseOn + AnsiBoldOn + line + AnsiBoldOff + AnsiReverseOff
		end
		puts line
		return true
	end
	
end
