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
# A façade for logging using Log4r.
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
