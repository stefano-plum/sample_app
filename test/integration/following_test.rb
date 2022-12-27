require "test_helper"

class Following < ActionDispatch::IntegrationTest
  def setup
    @user = users(:stefano)
    log_in_as(@user)
  end
end

class FollowPageTest < Following
  test "following page" do
    get following_user_path @user
    assert_response :unprocessable_entity
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
