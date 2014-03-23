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
# Services class, providing services like time, input/output and logging to the rest of the application
#
# For each service, there should be:
#  - A getter, using lazy initialization for the default versions of the service implementations
#  - A setter, so that test methods can put in their mock versions of the required services 
#

require 'array_twitter_facade'
require 'io_facade'
require 'log_facade'
require 'rand_facade'
require 'sha1'
require 'time_facade'

class Services
  
  @@digester = nil
  @@io = nil
  @@log = nil
  @@rand = nil
  @@time = nil
  @@twitter = nil
  
  def self.digester
    if (@@digester == nil)
      @@digester = SHA1.new
    end
    return @@digester
  end

  def self.io
    if (@@io == nil)
      @@io = IoFacade.new
    end
    return @@io
  end
  
  def self.log
    if (@@log == nil)
      @@log = LogFacade.new
    end
    return @@log
  end
    
  def self.rand
    if (@@rand == nil)
      @@rand = RandFacade.new
    end
    return @@rand
  end

  def self.time
    if (@@time == nil)
      @@time = TimeFacade.new
    end
    return @@time
  end

  def self.twitter
    if (@@twitter == nil)
      @@twitter = ArrayTwitterFacade.new
    end
    return @@twitter
  end

  def self.digester= (digester)
    @@digester = digester
  end

  def self.io= (io)
    @@io = io
  end
  
  def self.log= (log)
    @@log = log
  end
  
  def self.rand= (rand)
    @@rand = rand
  end

  def self.time= (time)
    @@time = time
  end

  def self.twitter= (twitter)
    @@twitter = twitter
  end
end
