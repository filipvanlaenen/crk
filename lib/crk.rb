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
# The CRK task engine
#

require 'cache'
require 'calculation_task'
require 'log4r_facade'
require 'services'
require 'twitter_facade'
require 'yaml'

class Crk

	TasksKey = 'tasks'

	attr_reader :state

	def initialize(configuration_yaml)
		load_configuration(configuration_yaml)
		load_state
	end
	
	def load_yaml_file(yaml_file)
		return YAML::load(Services.io.read(yaml_file))
	end

	def load_configuration(configuration_yaml)
		@configuration = load_yaml_file(configuration_yaml)
		@state_yaml = @configuration['state_yaml']
		initialize_logging
		initialize_digester
		initialize_calculation_task_class
		initialize_segment_completion_task_class
		initialize_twitter_service
		Services.log.debug "Configuration loaded from #{configuration_yaml}."
	end
	
	def initialize_logging
		log_filename = @configuration['log_filename']
		if (log_filename != nil)
			Services.log = Log4rFacade.new(log_filename)
		end
	end
	
	def initialize_twitter_service
		if (@configuration['oauth_consumer_key'] != nil)
			Services.twitter.configure(@configuration['oauth_consumer_key'], @configuration['oauth_consumer_secret'], @configuration['oauth_access_token'], @configuration['oauth_access_token_secret'])
		end
	end
	
	def initialize_digester
		if (@configuration['digester'] != nil)
			require @configuration['digester_libfile']
			klass = Object.const_get(@configuration['digester'])
			Services.digester = klass.new
		end
	end
	
	def initialize_calculation_task_class
		CalculationTask.max_iterations_allowed = @configuration['max_iterations_allowed']
		CalculationTask.cpu_share = @configuration['cpu_share']
	end
	
	def initialize_segment_completion_task_class
		SegmentCompletionTask.cache = Cache.new(@configuration['cache_dir'])
	end
	
	def load_state
		@state = load_yaml_file(@state_yaml)
		Services.log.debug "State loaded from #{@state_yaml}."
	end
	
	def save_state
		Services.io.write(@state_yaml, @state.to_yaml)
	end
	
	def continue
		while (true)
			task = pick_task
			add_tasks(task.perform)
			save_state
		end
	end
	
	def tasks
		return @state[TasksKey]
	end
	
	def add_tasks(tasks)
		@state[TasksKey] = @state[TasksKey] + tasks
	end
	
	def pick_task
		if (tasks.empty?)
			Services.log.info("No tasks available; will create a new, random calculcation task.")
			return CalculationTask.random_new(@configuration['distinction_scale'])
		else
			return tasks.shift
		end
	end
		
end
