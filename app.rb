require 'bundler/setup'
require 'redis'

redis = Redis.new(
  url: 'redis://mymaster',
  sentinels: [{ host: 'redissentinel', port: 26379 }],
  role: :master
)

i = 0
loop do
  puts "------------"
  puts "---LOOP #{i}---"
  puts "------------"
  STDOUT.flush
  sleep 15
  redis.set i, i
  i += 1
end

