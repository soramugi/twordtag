class TagsController < ApplicationController
  before_action :set_tags

  # GET /tags
  def index
    render 'show'
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  private
  def set_tags
    if word = params[:word]
      @tags = Tag.where(word: word).order('id desc')
    else
      @tags = Tag.all.order('id desc')
    end
  end
end
