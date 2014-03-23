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
# Digester superclass. The class implements methods to create the correct Twitter messages.
#
# Subclasses must provide the following methods:
#  - twitter_tag
#  - algorithm_name
#

class Digester

  def segment_twitter_message(result)
    return "#{algorithm_name}{#{result.length}}(#{result.start}) = #{result.result} ##{twitter_tag}"
  end
  
  def colliding_segments_twitter_message(result1, result2)
    return "#{algorithm_name}{#{result1.length}}(#{result1.start}) = #{algorithm_name}{#{result2.length}}(#{result2.start}) ##{twitter_tag}"
  end
  
  def collision_twitter_message(message1, message2)
    return "#{algorithm_name}(#{message1}) = #{algorithm_name}(#{message2}) ##{twitter_tag}"
  end

end
