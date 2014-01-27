namespace :tags do
  desc "tags create"
  task :create => :environment do
    datetime = Time.parse(Time.now.strftime("%Y-%m-%d")).to_datetime - 1
    User.all.each do |user|
      next unless user.provider == 'twitter'
      Tag.create_with_user_tweet user, datetime
    end
  end
end
