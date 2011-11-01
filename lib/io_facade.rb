#
# Façade for IO to files
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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
