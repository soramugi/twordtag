class TopsController < ApplicationController

  # GET '/'
  def index
  end

  #
  # GET|POST '/analysis'
  # GET|POST '/analysis.json'
  #
  def analysis
    @str = params[:text] ||= '解析対象の文字列'
    @words = Tag.counter(Tag.generate(@str))
  end
end
