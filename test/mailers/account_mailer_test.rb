require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase
  
  test "account_activation" do
    account = accounts(:michael)
    account.activation_token = Account.new_token
    mail = AccountMailer.account_activation(account)
    assert_equal "Account activation", mail.subject
    assert_equal [account.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match account.first_name,         mail.body.encoded
    assert_match account.activation_token,   mail.body.encoded
    assert_match CGI::escape(account.email), mail.body.encoded
  end
  
  test "password_reset" do
    account = accounts(:michael)
    account.reset_token = Account.new_token
    mail = AccountMailer.password_reset(account)
    assert_equal "Password reset", mail.subject
    assert_equal [account.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match account.reset_token,        mail.body.encoded
    assert_match CGI::escape(account.email), mail.body.encoded
  end
  
end
