class TopsController < ApplicationController
  def index
    dict_dir=Twordtag::Application.config.okura_dict_dir
    $stdout = StringIO.new
    tagger=Okura::Serializer::FormatInfo.create_tagger dict_dir
    $stdout = STDOUT

    str='解析対象の文字列'
    @nodes=tagger.parse(str)
  end

  # TODO 単語解析用のページ作成
  def analysis
  end
end
