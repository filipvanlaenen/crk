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
# Unit tests for Crk
#

require 'test/unit'

require 'crk'
require 'dummy_io_facade'
require 'dummy_rand_facade'

ConfigYaml = 'config.yaml'
StateYaml = 'state.yaml'

DistinctionScale = 4

class DummyIoFacade < IoFacade
  
  def initialize
    @files = {}
    @files[ConfigYaml] = "--- \nmax_iterations_allowed: 5\ndigester: SHA1\ndigester_libfile: sha1.rb\ndistinction_scale: #{DistinctionScale}\nstate_yaml: #{StateYaml}"
    @files[StateYaml] = "--- \ntasks: []"
  end
  
  def read(filename)
    return @files[filename]
  end
  
  def write(filename, content)
    @files[filename] = content
  end
  
end

class CrkUnitTest < Test::Unit::TestCase

  TaskStart = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
  TaskCurrentPoint = '000000000A176D80EB9C3DBECA921EB0B4AFCFB8'
  TaskCurrentLength = 0

  def setup
    Services.io = DummyIoFacade.new
    Services.rand = DummyRandFacade.new(0.5)
    Services.log = LogFacade.new    
    @crk = Crk.new(ConfigYaml)
    @task = CalculationTask.new(TaskStart, TaskCurrentPoint, TaskCurrentLength)
  end

  # initialize
  
  def test_logs_that_configuration_has_been_loaded
    assert_equal "Configuration loaded from #{ConfigYaml}.", Services.log.debug_message(0)
  end

  def test_logs_that_state_has_been_loaded
    assert_equal "State loaded from #{StateYaml}.", Services.log.debug_message(1)
  end

  # add_tasks
  
  def test_has_one_task_after_adding_one
    @crk.add_tasks([@task])
    assert_equal [@task], @crk.tasks
  end
  
  # pick_task
  
  def test_pick_task_gets_first_task
    @crk.state['tasks'] = [@task]
    assert_equal @task, @crk.pick_task
  end
  
  def test_pick_task_creates_new_calculation_task_when_tasks_empty
    assert_equal CalculationTask.random_new(DistinctionScale), @crk.pick_task
  end
  
  def test_log_pick_task_creates_new_calculation_task_when_tasks_empty
    @crk.pick_task
    assert_equal "No tasks available; will create a new, random calculcation task.", Services.log.info_message(0)
  end

  # tasks
  
  def test_tasks_is_empty_when_empty_state_file
    assert @crk.tasks.empty?
  end
  
end