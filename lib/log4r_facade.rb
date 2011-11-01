#
# A façade for logging using Log4r
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'rubygems'
require 'log4r'

include Log4r

class Log4rFacade
	
	def initialize(filename)
		@log = Logger.new('log')
		@log.level = INFO
		file_outputter = FileOutputter.new('fileOutputter', :filename =>  filename, :trunc => false)
		pattern_formatter = PatternFormatter.new(:pattern => "%d %l: %M")
		file_outputter.formatter = pattern_formatter
		@log.outputters = file_outputter
	end
	
	def debug(message)
		@log.debug(message)
	end
	
	def error(message)
		@log.error(message)
	end

	def fatal(message)
		@log.fatal(message)
	end

	def info(message)
		@log.info(message)
	end
	
	def warn(message)
		@log.warn(message)
	end
	
end
