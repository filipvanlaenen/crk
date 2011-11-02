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
# A façade for logging.
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
