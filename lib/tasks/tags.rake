namespace :tags do
  desc "tags create"
  task :create, [:date,:limit] => :environment do |task,args|
    dates = args.date ? [Time.parse(args.date).to_date] : [
      Time.now.to_date - 1,
      Time.now.to_date - 2,
      Time.now.to_date - 3,
      Time.now.to_date - 4,
      Time.now.to_date - 5,
    ]
    limit = args.limit ? args.limit.to_i : 1

    # TODO tags作成されてないユーザーを積極的に取得できるように
    # 1度のタスク実行で1ユーザーのtagしか作れないように
    user_count = 0
    User.all.find_in_batches do |users|
      users.each do |user|
        is_create_tag = false
        dates.each do | date|
          is_create_tag = true unless user.create_tags(date) == nil
        end
        user_count += 1 if is_create_tag
        break if user_count >= limit
      end
      break if user_count >= limit
    end
  end
end
