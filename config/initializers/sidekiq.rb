redis_conn = proc {
  # set the same redis instance from dataStore initializer 
  DataStore.redis
}
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end

# set default setting for all workers
#Sidekiq.default_worker_options = { :queue => :default, :retry => false, :backtrace => true }