require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
ENV.update YAML.load_file('config/settings.yml')[Rails.env] rescue {}
I18n.enforce_available_locales = false

module Twordtag
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.title = 'TWordTag'
    config.twitter_consumer_key    = ENV['TWITTER_CONSUMER_KEY']    || 'YOUR_TWITTER_CONSUMER_KEY'
    config.twitter_consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] || 'YOUR_TWITTER_CONSUMER_SECRET'
    config.okura_dict_dir = Dir[Rails.root.join('dict', 'okura-dic').to_s]
  end
end
