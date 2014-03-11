require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test "should show tag" do
    get :show, word: @tag
    assert_response :success
  end

  test "should post create" do
    get :create, name: users(:one).name
    assert_redirected_to user_path(users(:one).name)
  end
end
