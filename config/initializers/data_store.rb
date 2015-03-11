module DataStore
  def self.redis
    #@redis ||= Redis.new(:host => (ENV["REDIS_HOST"] || 'localhost'), :port => (ENV["REDIS_PORT"] || 6379))
    @redis ||=Redis.new(:url => (ENV["REDIS_URL"] || 'redis://127.0.0.1:6379/1'))
  end

  def self.tag_prefix
    @redis_tag_prefix ||= "#{APIConstants::SYSTEM_CONSTANTS::REDIS_KEY_PREFIX}-" + Rails.env
  end

end
