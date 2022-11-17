require "test_helper"

class UsersEditSetup < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:stefano)
    log_in_as(@user)
  end

end

class UsersEditTemplate < UsersEditSetup

  test "render correct template" do 
    get edit_user_path(@user)
    assert_template 'users/edit' 
  end

end

class UsersUnsuccessfulEdit < UsersEditSetup

  test "unsuccessful edit" do
    get edit_user_path(@user)
    patch user_path(@user), params: {
      user: {
        name: '',
        username: 'invalid/username',
        email: 'invalid@email',
        password: 'boo',
        password_confirmation: 'foo'
      }
    }
    # assert_template 'users/edit'
    assert_select '#error_explanation > ul > li' do
      assert_select 'li', count: 5
    end 
    assert_select 'div.alert', "The form contains 5 errors."
  end
  
end

class UsersSuccessfulEdit < UsersEditSetup

  test "successful edit" do
    get edit_user_path(@user)
    name = "Foo Bar"
    username = "foobar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user: {
        name: name,
        username: username,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal username, @user.username
    assert_equal email, @user.email
  end 

end