class User < ActiveRecord::Base
  has_many  :tags
  has_many  :tag_logs
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
      end
    end
  end

  def create_tags date = nil
      date = date || yesterday
      return unless provider == 'twitter'
      return if TagLog.find_by_user_id_and_date(id, date)
      Tag.create_with_user_tweet self, date
      TagLog.create(user_id: id, date: date)
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = Twordtag::Application.config.twitter_consumer_key
      config.consumer_secret     = Twordtag::Application.config.twitter_consumer_secret
      config.access_token        = token
      config.access_token_secret = secret
    end
  end

  def tweets date = nil
    start_date = date || yesterday
    end_date   = start_date + 1
    is_retry   = true
    tweet_id   = nil
    day_tweets = []
    while_count = 1
    while is_retry && while_count <= 50 do
      while_count += 1
      timeline = user_timeline(tweet_id)
      break if timeline.count == 0
      timeline.each do |tweet|
        tweet_id = tweet.id
        next if tweet.retweet?
        next unless tweet.created_at < end_date
        if start_date > tweet.created_at
          is_retry = false
          break
        end
        next unless start_date <= tweet.created_at
        day_tweets << tweet
      end
    end
    day_tweets
  end

  # Railsで指定したtime_zoneを使いたいのでTimeでDateを求める
  def yesterday
    Time.now.to_date - 1
  end

  private
  def user_timeline tweet_id
    client.user_timeline(uid.to_i, tweet_options(tweet_id))
  end
  def tweet_options tweet_id
    options = {count: 50}
    options[:max_id] = tweet_id - 1 if tweet_id
    options
  end
end
