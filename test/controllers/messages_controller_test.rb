require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  
  # test "should get inbox" do
  #   get :inbox
  #   assert_response :success
  # end

  # test "should get sent" do
  #   get :sent
  #   assert_response :success
  # end

  # test "should get spam" do
  #   get :spam
  #   assert_response :success
  # end

  # test "should get trash" do
  #   get :trash
  #   assert_response :success
  # end

  test "should redirect create when not logged in" do
    assert_no_difference 'Message.count' do
      post :create, message: { sender_id: accounts(:michael).id,
                               reciever_id: accounts(:steve).id,
                               title: "test-post",
                               content: "Lorem ipsum" }
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
