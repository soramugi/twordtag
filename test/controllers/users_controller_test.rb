require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, {name: users(:one).name}
    assert_response :success
  end

  test "should get show_date" do
    tag = users(:one).tags.first
    get :show_date,
      {name: users(:one).name, year: tag.date.year, month: tag.date.month, day: tag.date.day}
    assert_response :success
  end

end
