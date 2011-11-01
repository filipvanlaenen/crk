#
# A façade for logging
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class LogFacade
	
	Debug = "DEBUG"
	Error = "ERROR"
	Fatal = "FATAL"
	Info = "INFO"
	Warn = "WARN"
	
	def initialize
		@messages = {Debug => [], Error => [], Fatal => [], Info => [], Warn => []}
	end
	
	def log(level, message)
		@messages[level]  << message
	end
	
	def get_message(level, i)
		return @messages[level][i]
	end
	
	def debug(message)
		log(Debug, message)
	end
	
	def debug_message(i)
		get_message(Debug, i)
	end
	
	def error(message)
		log(Error, message)
	end
	
	def error_message(i)
		get_message(Error, i)
	end

	def fatal(message)
		log(Fatal, message)
	end

	def info(message)
		log(Info, message)
	end

	def info_message(i)
		get_message(Info, i)
	end

	def warn(message)
		log(Warn, message)
	end
	
	def warn_message(i)
		get_message(Warn, i)
	end
	
end
