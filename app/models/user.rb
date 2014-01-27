class User < ActiveRecord::Base
  has_many :tags
  validates :provider, presence: :true
  validates :uid, presence: :true
  validates :name, presence: :true

  validates_uniqueness_of :uid, scope: :provider

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]

      if user.provider == "twitter"
        user.name      = auth["info"]["nickname"]
        user.image_url = auth["info"]["image"]
        user.token     = auth["credentials"]["token"]
        user.secret    = auth["credentials"]["secret"]
      else
        user.name      = auth["info"]["name"]
      end
    end
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Twordtag::Application.config.twitter_consumer_key
      config.consumer_secret     = Twordtag::Application.config.twitter_consumer_secret
      config.access_token        = token
      config.access_token_secret = secret
    end
  end

  # TODO test
  def tweets datetime = nil
    start_time = datetime || yesterday
    end_time   = start_time + 1
    is_retry   = true
    tweet_id   = nil
    day_tweets = []
    while is_retry do
      user_timeline(tweet_id).each do |tweet|
        tweet_id = tweet.id
        next if tweet.retweet?
        next unless tweet.created_at < end_time
        if start_time > tweet.created_at
          is_retry = false
          break
        end
        next unless start_time <= tweet.created_at
        day_tweets << tweet
      end
    end
    day_tweets
  end

  private
  # Railsで指定したtime_zoneを使いたいのでTimeでDateTimeを求める
  def yesterday
    now = Time.now
    Time.parse(now.strftime("%Y-%m-%d")).to_datetime - 1
  end
  def user_timeline tweet_id
    client.user_timeline(uid.to_i, tweet_options(tweet_id))
  end
  def tweet_options tweet_id
    options = {count: 50}
    options[:max_id] = tweet_id - 1 if tweet_id
    options
  end
end
