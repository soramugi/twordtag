class UsersController < ApplicationController
  before_action :set_user

  # GET /user/:name
  # TODO sql投げる回数多いのでまとめる
  def show
    @tag_logs = @user.tag_logs.order('date desc').page(params[:page]).per(5)
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
