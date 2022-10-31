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
end