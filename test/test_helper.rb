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
  
  module FixtureFileHelpers
    def rand_num(min,max,exception,halt=0)
      raise if halt == 3
      n = Range.new(min, max).to_a.sample
      rand_num(min,max,exception,halt+1) if n == exception
      n
    end
  end
  ActiveRecord::FixtureSet.context_class.send :include, FixtureFileHelpers
  
  def insert_messages
    accounts_6 = Account.order(:created_at).take(6)
    10.times do |n|
      title = Faker::Lorem.word
      content = Faker::Lorem.sentence(5)
      accounts_6.each { |account| account.messages.create!(reciever_id: n, title: title, content: content) }
    end
  end
    
  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end
    
    
end