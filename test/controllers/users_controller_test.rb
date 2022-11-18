require "test_helper"
require "minitest/reporters"
Minitest::Reporters.use!

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:stefano)
    @user2 = users(:ezequiel)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
end

class UserNotLoggedInEdit < UsersControllerTest

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        username: @user.username,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end

class UserLoggedInEdit < UsersControllerTest
  test "should redirect edit when loggen in as wrong user" do
    log_in_as(@user2)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when loggen in as wrong user" do
    log_in_as(@user2)
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        username: @user.username,
        email: @user.email
      }
    } 
    assert flash.empty?
    assert_redirected_to root_url
  end
end
