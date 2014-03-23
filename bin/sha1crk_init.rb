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
# Initializes a directory from which SHA1CRK can be run.
# The directory from which SHA1CRK will be run, must be the first parameter of the script.
#

require 'io_facade'
require 'yaml'
require 'rubygems'

local_sha1crk_dir = File.expand_path(ARGV[0])
configuration_yaml = File.join(local_sha1crk_dir, 'sha1crk-config.yaml')
state_yaml = File.join(local_sha1crk_dir, 'sha1crk-state.yaml')

io = IoFacade.new

if (File.exist?(configuration_yaml))
  value_status = 'current'
  configuration = YAML::load(io.read(configuration_yaml))
else
  value_status = 'default'
  configuration = {}
  configuration['digester'] = 'SHA1'
  configuration['digester_libfile'] = 'sha1.rb'
  configuration['distinction_scale'] = 4
  configuration['max_iterations_allowed'] = 1000000
  configuration['cpu_share'] = 0.1
  configuration['state_yaml'] = state_yaml
  configuration['log_filename'] = File.join(local_sha1crk_dir, 'sha1crk.log')
  configuration['cache_dir'] = File.join(local_sha1crk_dir, 'cache')
  configuration['oauth_consumer_key'] = nil
  configuration['oauth_consumer_secret'] = nil
  configuration['oauth_access_token'] = nil
  configuration['oauth_access_token_secret'] = nil
end

cpu_share = (configuration['cpu_share'] * 100).to_i
print "Enter the load on the CPU [0-100, #{value_status} #{cpu_share}]: "
cpu_share = STDIN.readline.chomp.to_i
if (cpu_share < 1 || cpu_share > 100)
  cpu_share = 0.1
else
  cpu_share = cpu_share.to_f / 100
end
puts "Registering a CPU load of #{(cpu_share * 100).to_i}%."
configuration['cpu_share'] = cpu_share

puts "If you haven't already done so, register a new app at http://dev.twitter.com/apps and supply the OAuth credentials below:"
oauth_consumer_key = configuration['oauth_consumer_key']
print "Consumer key [currently #{oauth_consumer_key}]: "
oauth_consumer_key = STDIN.readline.chomp
configuration['oauth_consumer_key'] = oauth_consumer_key unless oauth_consumer_key == '' 
oauth_consumer_secret = configuration['oauth_consumer_secret']
print "Consumer secret [currently #{oauth_consumer_secret}]: "
oauth_consumer_secret = STDIN.readline.chomp
configuration['oauth_consumer_secret'] = oauth_consumer_secret unless oauth_consumer_secret == '' 
oauth_access_token = configuration['oauth_access_token']
print "Access token [currently #{oauth_access_token}]: "
oauth_access_token = STDIN.readline.chomp
configuration['oauth_access_token'] = oauth_access_token unless oauth_access_token == '' 
oauth_access_token_secret = configuration['oauth_access_token_secret']
print "Access token secret [currently #{oauth_access_token_secret}]: "
oauth_access_token_secret = STDIN.readline.chomp
configuration['oauth_access_token_secret'] = oauth_access_token_secret unless oauth_access_token_secret == '' 

io.write(configuration_yaml, configuration.to_yaml)
puts "Created the configuration file: #{configuration_yaml}"

write_state_yaml = true
if (File.exist?(state_yaml))
  print 'Should the state be flushed [YN, default N]: '
  flush_state = STDIN.readline.chomp.upcase
  write_state_yaml = (flush_state == 'Y')
end
if (write_state_yaml)
  state = {}
  state['tasks'] = []
  io.write(state_yaml, state.to_yaml)
  puts "Created an empty, default state file: #{state_yaml}"
else
  puts "Kept the current state file."
end