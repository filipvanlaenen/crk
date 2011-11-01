#
# Cache
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class Cache
	
	def initialize(base_dir)
		@base_dir = base_dir
	end
	
	def store(result)
		Services.io.append(File.join(@base_dir, result.cache_filename), result.cache_line)
	end
	
	def include?(result)
		file = Services.io.read(File.join(@base_dir, result.cache_filename))
		if (file == nil)
			return false
		end
		lines = file.split(/\n/)
		return lines.include?(result.cache_line)
	end
	
	def get_matching_segment(files_pattern, segment_pattern, exclude_cache_line)
		file_names = Services.io.glob(files_pattern, @base_dir)
		file_names.each do | file_name |
			file = Services.io.read(File.join(@base_dir, file_name))
			lines = file.split(/\n/)
			lines.each do | line |
				if ((line != exclude_cache_line) && (nil != (line =~ segment_pattern)))
					return Result.from_line(line)
				end
			end
		end
		return nil
	end
	
	def get_colliding_segment(result)
		return get_matching_segment(result.collision_files_pattern, result.collision_pattern, result.cache_line)
	end
	
	def get_next_segment_in_path(result)
		return get_matching_segment(result.next_segment_in_path_files_pattern, result.next_segment_in_path_pattern, result.cache_line)
	end
	
end
