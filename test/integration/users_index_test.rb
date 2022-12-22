require "test_helper"

class UserIndex < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:stefano)
    @user = users(:ezequiel)
  end
end

class UserIndexAdmin < UserIndex
  def setup
    super
    log_in_as(@admin)
    get users_path
  end
end

class UserIndexAdminTest < UserIndexAdmin
  
  test "should render the index page" do
    assert_template "users/index"
  end

  test "should paginate users" do
    assert_select 'div.pagination'
  end

  test "index should include pagination" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
  end

  test "should have delete links" do
    first_page_of_users = User.where(activated: true).paginate(page: 1, per_page: 15)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.username
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: "delete"
      end
    end
  end
  
  test "should display only activated users" do
    User.paginate(page: 1, per_page: 15).first.toggle!(:activated)
    assigns(:users).each do |user| 
      assert user.activated?
    end
  end 
end

class UsersNonAdminIndexText < UserIndex
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

  test "should not have delete links as non-admin" do
    log_in_as(@user)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
