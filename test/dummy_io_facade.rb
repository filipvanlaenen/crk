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
# Dummy IO façade
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
