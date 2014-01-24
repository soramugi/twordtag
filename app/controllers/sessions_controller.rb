class SessionsController < ApplicationController
  def index

    dict_dir=Twordtag::Application.config.okura_dict_dir
    $stdout = StringIO.new
    tagger=Okura::Serializer::FormatInfo.create_tagger dict_dir
    $stdout = STDOUT

    str='解析対象の文字列'
    @nodes=tagger.parse(str)
  end

  def create
    auth = request.env["omniauth.auth"]
    user =
      User.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
      User.create_with_omniauth(auth)

    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed In!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed Out!"
  end
end
