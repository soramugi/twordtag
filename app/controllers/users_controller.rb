class UsersController < ApplicationController
  before_action :set_user

  # GET /user/:name
  # TODO sql投げる回数多いのでまとめる
  def show
    @tag_logs = @user.tag_logs.order('date desc').page(params[:page]).per(5)
  end

  # GET /user/:name/:year/:month/:day
  def show_date
  end

  private
  def set_user
    @user = User.find_by_name(params[:name])
  end
end
