require 'test_helper'

class AccountsSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

 test "invalid signup information" do
    get root_path
    assert_no_difference 'Account.count' do
      post accounts_path, account: { first_name:  "",
                               last_name:  "schmoe",
                               email: "account@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'static_pages/home'
    assert_select 'div#error_explanation'
    assert_select 'div#error_explanation ul li'
  end
  
  test "valid signup information with account activation" do
    get root_path
    assert_difference 'Account.count', 1 do
      post accounts_path, account: { first_name:  "Example",
                                            last_name:  "Account",
                                            email: "account@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    account = assigns(:account)
    assert_not account.activated?
    # Try to log in before activation.
    log_in_as(account)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(account.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(account.activation_token, email: account.email)
    assert account.reload.activated?
    follow_redirect!
    assert_template 'accounts/show'
    assert is_logged_in?
  end
  
end