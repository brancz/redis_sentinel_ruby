require 'bundler/setup'
require 'redis'

redis_options = {
  url: 'redis://mymaster',
  sentinels: [{ host: 'redissentinel', port: 26379 }],
  role: :master
}

redis = Redis.new redis_options

Thread.new do
  loop do
    begin
      Redis.new(redis_options).subscribe('channel') do |on|
        on.message do |channel, msg|
          puts '---messaging---'
          puts msg
          puts '---------------'
          STDOUT.flush
        end
      end
    rescue => e
      puts '---message exception---'
      puts e
      puts '-----------------------'
      STDOUT.flush
    end
  end
end

begin
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
rescue => e
  puts '---loop exception---'
  puts e
  puts '--------------------'
  STDOUT.flush
end

