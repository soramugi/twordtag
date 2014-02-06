class Tag < ActiveRecord::Base
  belongs_to :user
  # TODO tag_logとのbelongs_toの指定方法しらべる
  #belongs_to :tag_log, foreign_key: 'user_id'

  def view_path
    "/user/#{user.name}/#{date.year}/#{date.month}/#{date.day}"
  end

  def self.create_with_user_tweet user,date = nil
    tags = []
    words = self.generate(self.tweet_compression(user.tweets date))
    self.counter(words).shift(20).each do |word,count|
      tags << create! do |record|
        record.user_id = user.id
        record.word    = word
        record.count   = count
        record.date    = date || user.yesterday
      end
    end
    tags
  end

  # 単語の回数計算
  #
  # 引数
  #   ['huge','foge','huge']
  #
  # 返り値
  #   [ ['huge', 2], ['foge', 1] ]
  def self.counter words
    words.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}.sort {|(a,av),(b,bv)| bv <=> av}
  end

  # 形態素解析
  def self.analysis text
    self.tagger.parse(text).mincost_path
  end

  # 単語選り分けて抜き出し
  #
  # 引数
  #   '果実と梅と果実'
  #
  # 返り値
  #   ["果実", "梅", "果実"]
  def self.generate text
    nouns_word         = []
    ignore_not_include = '名詞'
    ignore_include     = '名詞,数'
    ignore_word        = 'http'
    self.analysis(text).each do |node|
      next if node.word.left.text.scan(/#{ignore_not_include}/).blank?
      next unless node.word.left.text.scan(/#{ignore_include}/).blank?
      next unless node.word.surface.scan(/#{ignore_word}|^[ぁ-ん]$/).blank?
      nouns_word << node.word.surface
    end
    nouns_word
  end

  private
  def self.tagger
    dict_dir = Twordtag::Application.config.okura_dict_dir
    # gem内でputsしてるので握りつぶす
    $stdout = StringIO.new
    tagger = Okura::Serializer::FormatInfo.create_tagger dict_dir
    $stdout = STDOUT
    tagger
  end
  def self.tweet_compression tweets
    compression = ''
    tweets.each do |tweet|
      compression += ' ' + tweet.text
    end
    compression
  end
end
