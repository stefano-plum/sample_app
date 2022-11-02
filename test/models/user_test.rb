require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                    password: '4645718', password_confirmation: "4645718",
                    username: 'stefano' )
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = '  '
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = '  '
    assert_not @user.valid?
  end  

  test "username should be present" do
    @user.username = '  '
    assert_not @user.valid?
  end

  test "name should be not too long" do
    @user.name = 'a' * 51 
    assert_not @user.valid?
  end

  test "email should be not too long" do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test "username should be not too long" do
    @user.username = 'a' * 51
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@barbaz..com)
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be ivvalid"
    end
  end  

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test "username should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "username should be saved as lowercase" do
    mixed_case_username = "StEFaNo"
    @user.username = mixed_case_username
    @user.save
    assert_equal mixed_case_username.downcase, @user.reload.username
  end

  test "username should have no special characters" do
    not_valid_username = "example@"
    @user.username = not_valid_username
    @user.save
    assert_not @user.valid?
  end
end
