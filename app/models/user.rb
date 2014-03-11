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

  def tweet?
    tweet_status == 1
  end

  # tagの作成
  #
  # ==== Returns
  #
  # * [ Tag, Tag ] | error_obj
  def create_tags date = nil
    date = date || yesterday
    raise 'Not provider twitter' unless provider == 'twitter'
    raise 'Created done' if TagLog.find_by_user_id_and_date(id, date)
    tags = []
    ActiveRecord::Base.transaction do
      TagLog.create!(user_id: id, date: date)
      tags = Tag.create_with_user_tweet self, date
    end
    return tags
  rescue => e
    return e
  end

  def tag_logs_search_by_tag_word word
    tags = Tag.where(user_id: self.id, word: word)
    TagLog.where(user_id: self.id, date: tags.map {|t| t.date }).order('date desc')
  end

  # Twitter APIから情報を上書き
  def update_with_twitter_status
    return unless provider == 'twitter'
    _image_url = client.user.profile_image_url.to_s
    _name      = client.user.screen_name
    if _image_url != image_url || _name != name
      update_attributes! image_url: _image_url, name: _name
    end
  rescue => e
    return e
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
    options = {count: 500}
    options[:max_id] = tweet_id - 1 if tweet_id
    options
  end
end
