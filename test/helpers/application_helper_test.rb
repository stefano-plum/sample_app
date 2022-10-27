require "test_helper"
require "minitest/reporters"
Minitest::Reporters.use!

class ApplicationHelperTest < ActionView::TestCase
    test "full title helper" do
        assert_equal "Home | Ruby on Rails Tutorial Sample App", full_title("Home")
        assert_equal "Help | Ruby on Rails Tutorial Sample App", full_title("Help")
        assert_equal "About | Ruby on Rails Tutorial Sample App", full_title("About")
        assert_equal "Contact | Ruby on Rails Tutorial Sample App", full_title("Contact")
        assert_equal "Sign Up | Ruby on Rails Tutorial Sample App", full_title("Sign Up")
    end
end
