class Tag < ActiveRecord::Base
  belongs_to :user

  def self.create_with_user_tweet user,date = nil
    nouns = self.nouns(self.tweet_compression(user.tweets date))
    tags = []
    counter_nouns = nouns.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}
    counter_nouns = counter_nouns.sort {|(a,av),(b,bv)| bv <=> av}
    counter_nouns.shift(20).each do |word,count|
      next if count == 1
      tags << create! do |record|
        record.user_id = user.id
        record.word    = word
        record.count   = count
        record.date    = date || user.yesterday
      end
    end
    tags
  end

  # 形態素解析
  def self.analysis text
    self.tagger.parse(text).mincost_path
  end

  # 名詞のみ
  def self.nouns text
    nouns_word = []
    self.analysis(text).each do |node|
      nouns_word << node.word.surface unless node.word.left.text.scan(/名詞/).blank?
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
