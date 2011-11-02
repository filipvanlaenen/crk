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
# Façade for IO to files.
#

class IoFacade

	def append(filename, content)
		file = File.open(filename, 'a')
		file.puts(content) 
		file.close		
	end
	
	def glob(pattern, dir = nil)
		if (dir != nil)
			Dir.chdir(dir)
		end
		return Dir.glob(pattern)
	end		

	def read(filename)
		file = File.open(filename, 'r')
		content = ""
		line = file.gets
		while (line)
			content += line
			line = file.gets
		end
		file.close		
		return content
	end
	
	def write(filename, content)
		file = File.open(filename, 'w')
		file.puts(content) 
		file.close		
	end	
	
end
