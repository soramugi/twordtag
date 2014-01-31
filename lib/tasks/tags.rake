namespace :tags do
  desc "tags create"
  task :create, [:date] => :environment do |task,args|
    dates = args.date ?
      [Time.parse(args.date).to_date] :
      [
        Time.now.to_date - 1,
        Time.now.to_date - 2,
        Time.now.to_date - 3,
        Time.now.to_date - 4,
        Time.now.to_date - 5,
      ]

      # TODO tags作成されてないユーザーを積極的に取得できるように
      User.all.find_in_batches do |users|
        users.each do |user|
          dates.each do | date|
            user.create_tags date
          end
        end
      end
  end
end
