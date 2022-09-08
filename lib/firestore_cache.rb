class FirestoreCache
  MAX_RETRY_COUNT = 3

  def initialize(collection_id, key)
    @collection_id = collection_id
    @key = key
  end

  # @return [Boolean]
  def exists?
    with_retry("FirestoreCache#exists?") do
      ref = firestore.doc(cache_key)
      snap = ref.get
      snap&.exists?
    end
  end

  # @param params [Hash]
  def set(params)
    with_retry("FirestoreCache#set") do
      params[:expires_at] ||= Time.now + 300
      ref = firestore.doc(cache_key)
      ref.set(params)
    end
  end

  # Run within block with once
  # @param collection_id [String]
  # @param key [String]
  # @yield
  def self.with_once(collection_id, key)
    cache = FirestoreCache.new(collection_id, key)
    unless cache.exists?
      yield
      cache.set(data: "1")
    end
  end

  private

  def cache_key
    @collection_id + "/" + sha1(@key)
  end

  def sha1(str)
    Digest::SHA1.hexdigest(str)
  end

  def firestore
    @firestore ||= Google::Cloud::Firestore.new
  end

  def with_retry(label)
    yield
  rescue TypeError, GRPC::Unavailable => error
    retry_count ||= 0
    retry_count += 1

    raise error if retry_count > MAX_RETRY_COUNT

    logger.warn "[#{label}] cache_key=#{cache_key}, retry_count=#{retry_count}, error=#{error}"
    sleep 1
    retry
  end
end
