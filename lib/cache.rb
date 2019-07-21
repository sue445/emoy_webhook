module Cache
  require "digest/sha1"

  def self.get(key)
    client.get(sha1(key))
  rescue => e
    logger.warn(e)
    Rollbar.warning(e)
    nil
  end

  def self.set(key, value)
    client.set(sha1(key), value)
  rescue => e
    logger.warn(e)
    Rollbar.warning(e)
  end

  def self.exists?(key)
    !!get(key)
  end

  def self.flush_all
    client.flush_all
  end

  def self.client
    return @client if @client

    Dalli.logger.level = Logger::WARN

    @client = Dalli::Client.new(Global.memcached.servers, Global.memcached.options.to_hash.transform_keys(&:to_sym))
  end
  private_class_method :client

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
  private_class_method :logger

  def self.sha1(str)
    Digest::SHA1.hexdigest(str)
  end
  private_class_method :sha1
end
