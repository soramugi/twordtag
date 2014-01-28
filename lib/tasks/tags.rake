namespace :tags do
  desc "tags create"
  task :create => :environment do
    User.all.each do |user|
      user.create_tags
    end
  end
end
