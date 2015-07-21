require 'test_helper'

class AccountsSignupTest < ActionDispatch::IntegrationTest
  
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
  end
  
  test "valid signup information" do
    get root_path
    assert_difference 'Account.count', 1 do
      post_via_redirect accounts_path, account: { first_name: "Example",
                                            last_name:  "Account",
                                            email: "account@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'accounts/show'
  end
  
end