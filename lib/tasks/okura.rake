namespace :okura do
  desc "Compile okura dict"
  task :compile => :environment do
    `tar zxvf db/mecab-naist-jdic-0.6.3b-20111013.tar.gz -C db/`
    `bundle exec okura compile db/mecab-naist-jdic-0.6.3b-20111013/ config/okura-dic`
  end
end
