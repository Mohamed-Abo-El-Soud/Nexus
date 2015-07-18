require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = Account.new(first_name:"Michael", last_name:"Jackson", email:"MJackson@mail.com")
    @steve = accounts(:steve)
    @mad = accounts(:mad)
  end
  
  test "check if user is valid" do
    assert @user.valid?
    assert @steve.valid?
    assert @mad.valid?
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.first_name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.first_name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
end
