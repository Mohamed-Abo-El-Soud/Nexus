require 'test_helper'

class MailAssociationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = Account.new(name:"Michael", email:"MJackson@mail.com")
    @steve = accounts(:steve)
    @mad = accounts(:mad)
  end
  
  # test "" do
  #   en
  
  # test "check if user is valid" do
  #   assert @user.valid?
  #   assert_equal @steve.first_name, "Steve"
  #   assert @steve.valid?
  #   assert @mad.valid?
  # end
  
end
