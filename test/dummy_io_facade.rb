#
# Dummy IO façade
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'io_facade'

class DummyIoFacade < IoFacade
	
	def initialize
		@files = {}
	end
	
	def append(filename, content)
		if (@files.has_key?(filename))
			@files[filename] = @files[filename] + content
		else
			@files[filename] = content
		end
	end	
	
	def get(filename)
		return @files[filename]
	end
	
	def glob(file_pattern, dir = nil)
		pattern = Regexp.new(file_pattern.gsub(/\*/, '.*'))
		return @files.keys.select { | filename | nil != (filename =~ pattern)}
	end			
	
end