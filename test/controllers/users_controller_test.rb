require "test_helper"
require "minitest/reporters"
Minitest::Reporters.use!

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:stefano)
    @user = users(:ezequiel)
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
    get edit_user_path(@admin)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@admin), params: {
      user: {
        name: @admin.name,
        username: @admin.username,
        email: @admin.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end

class UserLoggedInEdit < UsersControllerTest
  test "should redirect edit when loggen in as wrong user" do
    log_in_as(@user)
    get edit_user_path(@admin)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when loggen in as wrong user" do
    log_in_as(@user)
    patch user_path(@admin), params: {
      user: {
        name: @admin.name,
        username: @admin.username,
        email: @admin.email
      }
    } 
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as @user
    assert_not @user.admin?
    patch user_path @user, params: {
      user: {
        admin: 1
      }
    }
    assert_not @user.admin?
  end
end

class UserNotLoggedInDestroy < UsersControllerTest
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path @admin
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @user
    assert_no_difference 'User.count' do
      delete user_path @admin
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
