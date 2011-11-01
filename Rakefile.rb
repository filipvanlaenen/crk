#
# CRK – Cracking cryptographic hash functions using the Web 2.0 
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
# Rake file, to run the unit tests, test coverage, static code analysis and mutation testing.
#

$:.unshift File.join(File.dirname(__FILE__), 'lib')

task :default => [:test]

task :all => [:test, :rcov, :roodi, :heckle]

# Test

%w[unit].each do | target |
	require 'rake/testtask'
	namespace :test do
		Rake::TestTask.new(target) do |t|
			t.libs << "test"
			t.test_files = FileList["test/*_#{target}_test.rb"]
			t.verbose = true
		end
	end
	task :test => "test:#{target}"
end

# RCov

namespace :rcov do
	desc "Delete aggregate coverage data."
	task(:clean) { rm_f "rcov.data" }
end

desc 'Aggregate code coverage for unit, functional and integration tests'
task :rcov => "rcov:clean"
%w[unit].each do |target|
	require 'rcov/rcovtask'
	namespace :rcov do
		Rcov::RcovTask.new(target) do |t|
			t.libs << "test"
			t.test_files = FileList["test/*_#{target}_test.rb"]
			t.output_dir = "qa/rcov/#{target}"
			t.verbose = true
			t.rcov_opts << '-x "\A/usr/local/lib,\A/var/lib/gems"'
			t.rcov_opts << '--sort coverage'
			t.rcov_opts << '--sort-reverse'
			t.rcov_opts << '--text-report'
			t.rcov_opts << '--aggregate rcov.data'
		end
	end
	task :rcov => "rcov:#{target}"
end

# Roodi

desc "Static code analysis with Roodi"
task :roodi do
	puts "Running static code analysis with Roodi:"
	roodifile = "qa/roodi.log"
	cmd = "roodi -config=roodi.yaml lib/*.rb > #{roodifile}"
	system(cmd)
	result = read_file(roodifile)
	if (result.include?("Found 0 errors."))
		puts "No issues found."
	else
		raise result
	end
end

# Heckle

namespace :heckle do
	desc "Deleting all heckle log files from previous run."
	task(:clean) { system ("rm qa/heckle-*.log") }
end

desc "Mutation testing with Heckle"
task :heckle => "heckle:clean" do
	# Unit tests
	heckle('cache.rb', 'Cache', 'test/cache_unit_test.rb')
	heckle('calculation_task.rb', 'CalculationTask', 'test/calculation_task_unit_test.rb', nil, ['hexdecode', 'hexencode'])
	heckle('colliding_segments_task.rb', 'CollidingSegmentsTask', 'test/colliding_segments_task_unit_test.rb')
#	heckle('crk.rb', 'Crk', 'test/crk_unit_test.rb', nil, ['continue', 'initialize_calculation_task_class', 'initialize_logging', 'initialize_segment_completion_task_class', 'initialize_twitter_service', 'load_configuration', 'save_state'])
	heckle('digester.rb', 'Digester', 'test/sha1_unit_test.rb')
	heckle('ptsha1.rb', 'PTSHA1', 'test/ptsha1_unit_test.rb')
	heckle('result.rb', 'Result', 'test/result_unit_test.rb')
	heckle('segment_completion_task.rb', 'SegmentCompletionTask', 'test/segment_completion_task_unit_test.rb')
	heckle('tweet_task.rb', 'TweetTask', 'test/tweet_task_unit_test.rb')
	#heckle('sha1.rb', 'Sha1', 'test/sha1_unit_test.rb')
end

# Method to read the contents of a file

def read_file(filename)
	file = File.new(filename, "r")
	content = ""
	begin
		while (line = file.readline)
			content += line
		end
	rescue EOFError
		file.close
	end
	return content.strip
end
