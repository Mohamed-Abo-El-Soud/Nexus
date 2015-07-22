ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def logger
    Rails.logger
  end
  
  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:account_id].nil?
  end
  
  # Logs in a test account.
  def log_in_as(account, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       account.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:account_id] = account.id
    end
  end
  
  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
    
    
end
