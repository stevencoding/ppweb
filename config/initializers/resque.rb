require 'resque' # include resque so we can configure it

require 'resque-scheduler'
require 'resque/scheduler/server'

Resque.redis = "localhost:6379" # tell Resque where redis lives
