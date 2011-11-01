#
# Runs CRK with SHA-1
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'crk'
require 'twitter_facade'

Services.twitter = TwitterFacade.new

local_sha1crk_dir = File.expand_path(ARGV[0])

sha1crk = Crk.new(File.join(local_sha1crk_dir, 'sha1crk-config.yaml'))

sha1crk.continue