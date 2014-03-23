#
# CRK – Cracking cryptographic hash functions using the Web 2.0.
# Copyright © 2011,2014 Filip van Laenen <f.a.vanlaenen@ieee.org>
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
# Cache
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
