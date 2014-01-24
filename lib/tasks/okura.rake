namespace :okura do
  desc "Compile okura dict"
  task :compile => :environment do
    `wget https://s3-ap-northeast-1.amazonaws.com/twordtag/mecab-naist-jdic-0.6.3b-20111013.tar.gz -P tmp/`
    `tar zxvf tmp/mecab-naist-jdic-0.6.3b-20111013.tar.gz -C tmp/`
    `bundle exec okura compile tmp/mecab-naist-jdic-0.6.3b-20111013/ config/okura-dic`
  end
end
