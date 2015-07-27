require 'test_helper'

class AccountsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @account = accounts(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@account)
    get account_path(@account)
    assert_template 'accounts/show'
    patch account_path(@account), account: { first_name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'accounts/show'
  end
  
  test "successful edit with friendly forwarding" do
    get edit_account_path(@account)
    log_in_as(@account)
    assert_redirected_to edit_account_path(@account)
    
  # test "successful edit" do
  #   log_in_as(@account)
  #   get account_path(@account)
  #   assert_template 'accounts/show'
    first_name  = "Foo"
    last_name  = "Bar"
    email = "foo@bar.com"
    patch account_path(@account), account: { first_name:  first_name,
                                    last_name:  last_name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @account
    @account.reload
    assert_equal first_name,  @account.first_name
    assert_equal last_name,  @account.last_name
    assert_equal email, @account.email
  end
  
end
