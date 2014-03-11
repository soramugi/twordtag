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

  # POST /tags/create
  def create
    user = User.find_by_name(params[:name])
    date = Time.now.to_date
    1.upto 10 do |t|
      break if user.create_tags(date - t).is_a? Array
    end
    redirect_to user_path(user.name)
  end

  private
  def set_tags
    if @word = params[:word]
      @tags = Tag.where(word: @word).order('date desc').page params[:page]
    else
      @word = '@all'
      @tags = Tag.all.order('date desc').page params[:page]
    end
  end
end
