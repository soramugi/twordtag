namespace :tags do
  desc "tags create"
  task :create, [:date] => :environment do |task,args|
    date = args.date ? Time.parse(args.date).to_date : Time.now.to_date - 1
    User.all.each do |user|
      user.create_tags date
    end
  end
end
