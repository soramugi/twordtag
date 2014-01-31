class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    if !(user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]))
      user = User.create_with_omniauth(auth)
      user.create_tags
    end

    login(user)
    redirect_to user_path(user.name)
  end

  def destroy
    logout
    redirect_to root_url
  end
end
