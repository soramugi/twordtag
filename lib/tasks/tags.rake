namespace :tags do
  desc "tags create"
  task :create => :environment do
    #TODO test
    start_time = Time.mktime 2014, 1, 24, 00, 00, 00
    end_time   = Time.mktime 2014, 1, 24, 23, 59, 59
    User.all.each do |user|
      next unless user.provider == 'twitter'
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Twordtag::Application.config.twitter_consumer_key
        config.consumer_secret     = Twordtag::Application.config.twitter_consumer_secret
        config.access_token        = user.token
        config.access_token_secret = user.secret
      end

      is_retry = true
      tweet_id = nil
      while is_retry do
        options = {count: 50}
        # 最後に取得したツイート以前から取得させる
        options[:max_id] = tweet_id - 1 if tweet_id
        tweets = client.user_timeline(user.uid.to_i, options)
        tweets.each do |tweet|
          tweet_id = tweet.id
          next if tweet.retweet?
          is_retry = false if start_time > tweet.created_at
          next unless start_time <= tweet.created_at
          next unless tweet.created_at <= end_time
            puts tweet.created_at
            puts tweet.id
            puts tweet.text
        end
      end
    end
  end
end
