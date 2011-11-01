#
# Initializes a directory from which SHA1CRK can be run.
# The directory from which SHA1CRK will be run, must be the first parameter of the script.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'io_facade'
require 'yaml'
require 'rubygems'
require 'oauth'

local_sha1crk_dir = File.expand_path(ARGV[0])
configuration_yaml = 'sha1crk-config.yaml'
state_yaml = File.join(local_sha1crk_dir, 'sha1crk-state.yaml')
oauth_access_token_dump = File.join(local_sha1crk_dir, 'oauth_access_token.dump')

print "Enter the load on the CPU [0-100, default 10]: "
cpu_share = STDIN.readline.chomp.to_i
if (cpu_share < 1 || cpu_share > 100)
	cpu_share = 0.1
else
	cpu_share = cpu_share.to_f / 100
end
puts "Registering a CPU load of #{(cpu_share * 100).to_i}%."

configuration = {}
configuration['digester'] = 'SHA1'
configuration['digester_libfile'] = 'sha1.rb'
configuration['distinction_scale'] = 4
configuration['max_iterations_allowed'] = 1000000
configuration['cpu_share'] = cpu_share
configuration['state_yaml'] = state_yaml
configuration['log_filename'] = File.join(local_sha1crk_dir, 'sha1crk.log')
configuration['oauth_access_token_filename'] = oauth_access_token_dump
configuration['cache_dir'] = File.join(local_sha1crk_dir, 'cache')

state = {}
state['tasks'] = []

oauth_consumer = OAuth::Consumer.new "EydRraMLcqfGU53ttWm5A",
                     "qmxHDZtOSCSBACiRNEF03eR2ykycwzxjwj3p3RsWQ",
                      { :site => 'http://twitter.com/',
                        :request_token_path => '/oauth/request_token',
                        :access_token_path => '/oauth/access_token',
                        :authorize_path => '/oauth/authorize'}
 
oauth_request_token = oauth_consumer.get_request_token
puts "Place the following URL in your browser:"
puts "\t#{oauth_request_token.authorize_url}"
puts "and authenticate at OAuth with the Twitter account on which you want SHA1CRK to publish your results."
print "Enter the number they give you: "
oauth_pin = STDIN.readline.chomp

oauth_access_token = oauth_request_token.get_access_token(:oauth_verifier => oauth_pin)

io = IoFacade.new

io.write(File.join(local_sha1crk_dir, configuration_yaml), configuration.to_yaml)
io.write(state_yaml, state.to_yaml)
io.write(oauth_access_token_dump, Marshal.dump(oauth_access_token))