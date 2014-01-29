require 'test_helper'

class TopsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
  test "should get analysis" do
    get :analysis
    assert_response :success
  end
end
