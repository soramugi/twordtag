class TopsController < ApplicationController

  # GET '/'
  def index
  end

  #
  # GET|POST '/analysis'
  # GET|POST '/analysis.json'
  #
  def analysis
    dict_dir = Twordtag::Application.config.okura_dict_dir
    $stdout = StringIO.new
    tagger = Okura::Serializer::FormatInfo.create_tagger dict_dir
    $stdout = STDOUT

    @str = params[:text] ||= '解析対象の文字列'
    @nodes = tagger.parse(@str)
  end
end
