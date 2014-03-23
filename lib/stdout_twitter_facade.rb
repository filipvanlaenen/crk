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
# Class implementing the Twitter façade, but printing to stdout instead of posting to Twitter.
#

class StdoutTwitterFacade
  
  AnsiBoldOn = "\033[1m"
  AnsiBoldOff = "\033[22m"
  AnsiReverseOn = "\033[7m"
  AnsiReverseOff = "\033[27m"
  
  def initialize
    @start_time = Services.time.now
  end
    
  def tweet(message)
    seconds_since_start = Services.time.now - @start_time
    minutes_since_start = (seconds_since_start / 60).to_i
    seconds_since_start = seconds_since_start - 60 * minutes_since_start
    line = ("%3d" % minutes_since_start) + ":" + ("%04.1f" % seconds_since_start) + "  " + message
    if (message =~ /\{.*\}.*\{.*\}/)
      line = AnsiBoldOn + line + AnsiBoldOff
    elsif (message =~ /\(.*\).*\(.*\)/)
      line = AnsiReverseOn + AnsiBoldOn + line + AnsiBoldOff + AnsiReverseOff
    end
    puts line
    return true
  end
  
end
