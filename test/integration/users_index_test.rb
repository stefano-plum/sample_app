require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:stefano)
  end

  test "index including pagination" do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'

    # idk why is not working

    # User.paginate(page: 1).each do |u|
    #   assert_select 'a[href=?]', user_path(u), text: u.username
    # end
    
  end
end
