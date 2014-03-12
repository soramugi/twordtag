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
    limit = args.limit ? args.limit.to_i : 6

    # TODO tags作成されてないユーザーを積極的に取得できるように
    # 1度のタスク実行で6日分(ユーザー関係なく)のtagしか作れないように
    tags_create_count = 0
    User.all.find_in_batches do |users|
      users.each do |user|
        is_create_tag = false
        dates.each do | date|
          unless user.create_tags(date).is_a? RuntimeError
            is_create_tag = true
            tags_create_count += 1
          end
        end
        user.update_with_twitter_status
        if is_create_tag && user.tweet?
          # tag作成完了をツイートさせる
          tweet = dates.first.strftime('%Y/%m/%d のツイートからタグを抽出しました。 #twordtag')
          tweet += " http://www.twordtag.com/user/#{user.name}"
          user.client.update(tweet)
        end
        break if tags_create_count >= limit
      end
      break if tags_create_count >= limit
    end
  end
end
