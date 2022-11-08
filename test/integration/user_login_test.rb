require "test_helper"

class UserLogin < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:stefano)
  end

end

class InvalidPasswordTest < UserLogin

  test "login path" do
    get login_path
    assert_template "sessions/new"
  end

  test "login with valid username/email and invalid password" do
    post login_path, params: { session: { username: "ezequiel@example.com",
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

end  

class ValidLogin < UserLogin

  def setup
    super
    post login_path, params: { session: { username: @user.email, password: 'password' } }
  end

end

class ValidLoginTest < ValidLogin

  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "redirected after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end

class Logout < ValidLogin

  def setup
    super
    delete logout_path
  end

end

class LogoutTest < Logout

  test "succesful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_path
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

end  
