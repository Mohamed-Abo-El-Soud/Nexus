require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should get inbox" do
    get :inbox
    assert_response :success
  end

  test "should get sent" do
    get :sent
    assert_response :success
  end

  test "should get spam" do
    get :spam
    assert_response :success
  end

  test "should get trash" do
    get :trash
    assert_response :success
  end

end