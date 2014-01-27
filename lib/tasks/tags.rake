namespace :tags do
  desc "tags create"
  task :create => :environment do
    start_time = Time.mktime 2014, 1, 24
    datetime = start_time.to_datetime
    User.all.each do |user|
      next unless user.provider == 'twitter'
      Tag.create_with_user_tweet user.id, user.tweets, datetime
    end
  end
end
