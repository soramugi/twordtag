require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "self.create_with_omniauth" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :twitter,
      {
        'provider' => 'twitter',
        'uid' => '12345',
        'info' => { 'nickname' => 'yournickname', 'image' => 'http://example' },
        'credentials' => { 'token' => 'token_test', 'secret' => 'secret_test'}
      }
    )
    auth = OmniAuth.config.mock_auth[:twitter]

    assert User.create_with_omniauth auth
  end

  test "client" do
    user = users(:one)
    assert_instance_of Twitter::REST::Client, user.client
  end

  test "yesterday" do
    user = users(:one)
    assert_equal Time.now.to_date - 1, user.yesterday
  end

  test "tweets" do
    user = users(:one)
    user.stubs(:user_timeline).returns([])
    assert_equal [], user.tweets

    user.stubs(:user_timeline).returns([
        Hashie::Mash.new({id: 2, retweet?: true})
    ])
    assert_equal [], user.tweets

    user.stubs(:user_timeline).returns([
        Hashie::Mash.new({id: 2, retweet?: false, created_at: Time.now.to_date})
    ])
    assert_equal [], user.tweets

    user.stubs(:user_timeline).returns([
        Hashie::Mash.new({id: 2, retweet?: false, created_at: Time.now.to_date - 2})
    ])
    assert_equal [], user.tweets

    user.stubs(:user_timeline).returns([
        Hashie::Mash.new({id: 2, retweet?: false, created_at: Time.now.to_datetime - 1})
    ])
    assert_equal 50, user.tweets.count
  end

  test "create_tags" do
    user = users(:one)
    assert_nil user.create_tags
  end
end
