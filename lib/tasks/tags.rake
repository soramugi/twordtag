namespace :tags do
  desc "tags create"
  task :create => :environment do
    date = Time.now.to_date - 1
    User.all.each do |user|
      next unless user.provider == 'twitter'
      next if TagLog.find_by_user_id_and_date(user.id, date)
      Tag.create_with_user_tweet user, date
      TagLog.create(user_id: user.id, date: date)
    end
  end
end
