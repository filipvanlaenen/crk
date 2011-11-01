#
# A (partial) result
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class Result
	
	LeadingZeroesRegexp = /^0*[^0]/
	
	attr_reader :length, :result, :start
	
	def initialize(start, result, length)
		@start = start
		@result = result
		@length = length
	end
	
	def self.from_line(line)
		line =~ /([^\.]+)\.([^\.]+)\.([^\.]+)/
		start = $1
		result = $2
		length = $3.to_i
		return Result.new(start, result, length)
	end
	
	def ==(other_result)
		return (other_result.instance_of?(Result)) && (other_result != nil) && (@start == other_result.start) && (@result == other_result.result) && (@length == other_result.length)
	end	
	
	def cache_line
		return "#{@start}.#{@result}.#{@length}"
	end
	
	def cache_filename
		return "#{@start.slice(LeadingZeroesRegexp)}-#{@result.slice(LeadingZeroesRegexp)}.txt"
	end
	
	def collision_files_pattern
		return "*-#{@result.slice(LeadingZeroesRegexp)}.txt"
	end
	
	def next_segment_in_path_files_pattern
		return "#{@result.slice(LeadingZeroesRegexp)}-*.txt"
	end
	
	def collision_pattern
		return /.*\.#{@result}\..*/
	end

	def next_segment_in_path_pattern
		return /^#{@result}\..*\..*/
	end

end
