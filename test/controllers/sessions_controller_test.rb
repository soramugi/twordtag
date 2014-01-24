require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get create" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :twitter,
      {
        'provider' => 'twitter',
        'uid' => '12345',
        'info' => { 'nickname' => 'yournickname' }
      }
    )
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]

    get :create, { provider: 'twitter'}
    assert_response :redirect
    assert_not_nil session[:user_id]
  end

  test "should get destroy" do
    get :destroy
    assert_response :redirect
    assert_nil session[:user_id]
  end

end
