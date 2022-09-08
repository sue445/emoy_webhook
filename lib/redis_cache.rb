class RedisCache
  require "digest/sha1"

  attr_reader :key

  KEY_PREFIX = "emoy_webhook:"

  def initialize(key)
    @key = key
  end

  def cache_key
    KEY_PREFIX + sha1(key)
  end

  def get
    locker.lock do
      redis_value.value
    end
  rescue => e
    logger.warn(e)
    nil
  end

  def set(value)
    locker.lock do
      redis_value.value = value
    end
  rescue => e
    logger.warn(e)
  end

  def exists?
    !!get
  end

  # Run within block with once
  # @param key [String]
  # @yield
  def self.with_once(key)
    cache = RedisCache.new(key)
    unless cache.exists?
      yield
      cache.set("1")
    end
  end

  private

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  def sha1(str)
    Digest::SHA1.hexdigest(str)
  end

  def locker
    Redis::Lock.new(cache_key + ":lock", expiration: 15, timeout: 0.1)
  end

  def redis_value
    @redis_value ||= Redis::Value.new(cache_key, expiration: 300)
  end
end
