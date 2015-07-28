require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @account = accounts(:michael)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path, password_reset: { email: @account.email }
    assert_not_equal @account.reset_digest, @account.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    account = assigns(:account)
    # debugger
    # Wrong email
    get edit_password_reset_path(account.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive account
    account.toggle!(:activated)
    get edit_password_reset_path(account.reset_token, email: account.email)
    assert_redirected_to root_url
    account.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: account.email)
    assert_redirected_to root_url
    # Right email, right token
    puts edit_password_reset_path(account.reset_token, email: account.email)
    get edit_password_reset_path(account.reset_token, email: account.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", account.email
    # Invalid password & confirmation
    patch password_reset_path(account.reset_token),
          email: account.email,
          account: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(account.reset_token),
          email: account.email,
          account: { password:              "",
                  password_confirmation: "" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch password_reset_path(account.reset_token),
          email: account.email,
          account: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to account
  end
  
  
  
end
