require 'test_helper'

class AccountsLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @account = accounts(:michael)
  end
  
  
  test "login with valid information followed by logout" do
    get root_path
    post login_path, session: { email: @account.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @account
    follow_redirect!
    assert_template 'accounts/show'
    assert_select "[data-target=\"log-in\"]", count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", account_path(@account)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "[data-target=\"log-in\"]", count: 2
    assert_select "a[href=?]", logout_path,            count: 0
    assert_select "a[href=?]", account_path(@account), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@account, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@account, remember_me: '0')
    assert_nil cookies['remember_token']
  end
  
end
