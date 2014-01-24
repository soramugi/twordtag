# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Twordtag::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'd2ab7ec37a211ba9a66c747acc3a7e3f60f7a5404228e4ac140ee4bdc93988fdf82a5e97dc749173764edd44f4078b5c19d54f72f8b8b8c522c5c60ee3d917a6'
