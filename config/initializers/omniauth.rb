Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    Twordtag::Application.config.twitter_consumer_key,
    Twordtag::Application.config.twitter_consumer_secret,
    display: 'popup'
end
