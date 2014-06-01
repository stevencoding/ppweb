require 'resque' # include resque so we can configure it

require 'resque-scheduler'
require 'resque/scheduler/server'

$redis = Redis.new(host: "localhost", port: "6379")

Resque.redis = $redis
