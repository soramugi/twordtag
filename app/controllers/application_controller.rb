class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :login?, :myid, :myname, :myimage

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    def login?
      !!session[:user_id]
    end
    def myid
      session[:user_id]
    end
    def myname
      session[:name]
    end
    def myimage
      session[:image_url]
    end
    def login user
      session[:user_id]   = user.id
      session[:name]      = user.name
      session[:image_url] = user.image_url
    end
    def logout
      session[:user_id]   = nil
      session[:name]      = nil
      session[:image_url] = nil
    end
end
