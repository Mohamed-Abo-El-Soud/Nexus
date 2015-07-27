require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  def setup
    @account = accounts(:michael)
    @other_account = accounts(:archer)
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to root_url
  end
  
  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  
  test "should redirect update when not logged in" do
    patch :update, id: @account, account: { first_name: @account.first_name, email: @account.email }
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong account" do
    log_in_as(@other_account)
    patch :update, id: @account, account: { first_name: @account.first_name, email: @account.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Account.count' do
      delete :destroy, id: @account
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_account)
    assert_no_difference 'Account.count' do
      delete :destroy, id: @account
    end
    assert_redirected_to root_url
  end

end
