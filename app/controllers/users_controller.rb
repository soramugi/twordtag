class UsersController < ApplicationController
  before_action :set_user

  # GET /user/:name
  # GET /user/:name.json
  def show
    tags = @user.tags.order('date desc').limit(100)
    @tags = tags.inject(Hash.new(0)) { |hash, a|
      hash[a.word] += a.count; hash
    }.sort {|(a,av),(b,bv)| bv <=> av}
  end

  def search
    @word = params[:word]
    @tag_logs = @user.tag_logs_search_by_tag_word(@word).page(params[:page]).per(5)
  end

  # GET /user/:name/:year/:month/:day
  def show_date
    @date    = date_param_parse
    @tag_log = @user.tag_logs.find_by_date(@date)
  end

  # PATCH/PUT /users/:name
  def update
    @user.update(user_params) if myid == @user.id
    redirect_to user_path(@user.name)
  end

  private
  def date_param_parse
    Time.parse("#{params[:year]}/#{params[:month]}/#{params[:day]}").to_date
  end
  def set_user
    @user = User.find_by_name(params[:name])
  end
  def user_params
    params.require(:user).permit(:tweet_status)
  end
end
