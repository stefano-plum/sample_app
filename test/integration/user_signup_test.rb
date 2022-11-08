require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, params: {
        user: {
          username: '',
          name: '',
          email: 'email@invalid.com',
          password: 'foo',
          password_confirmation: 'bar'
        }
      }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid signup information" do
    assert_difference "User.count" do
      post users_path, params: {
        user: {
          username: 'testUsername',
          name: 'testName',
          email: 'testEmail@test.com',
          password: 'testPassword',
          password_confirmation: 'testPassword'
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash[:success]
    assert is_logged_in?
  end
end