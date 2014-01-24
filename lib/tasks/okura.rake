namespace :okura do
  desc "Compile okura dict"
  task :compile => :environment do
    require 'open-uri'
    path = 'https://s3-ap-northeast-1.amazonaws.com/twordtag/mecab-naist-jdic-0.6.3b-20111013.tar.gz'
    fileName = File.basename(path)
    open('tmp/'+fileName, 'wb') do |output|
      open(path) do |data|
        output.write(data.read)
      end
    end

    `tar zxvf tmp/mecab-naist-jdic-0.6.3b-20111013.tar.gz -C tmp/`
    `bundle exec okura compile tmp/mecab-naist-jdic-0.6.3b-20111013/ config/okura-dic`
  end
end
