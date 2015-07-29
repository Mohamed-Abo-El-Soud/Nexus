require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  def setup
    @account = Account.create(first_name: "Michael", last_name: "Jackson", email: "MJackson@mail.com",
                        password: "foobar", password_confirmation: "foobar")
    @other_account = Account.create(first_name: "Joe", last_name: "Man", email: "JMan@mail.com",
                        password: "foobar", password_confirmation: "foobar")
    @message = @account.messages.build(title: "Foo Bar",
                                       content: "Lorem ipsum dolor sit amet...",
                                       reciever_id: @other_account.id)
    @first = messages(:steve_mail)
    @second = messages(:max_mail)
    @steve = accounts(:steve)
    @mad = accounts(:mad)
  end
  
  test "must be valid" do
    assert @message.valid?
  end
  
  test "content length validity" do
    assert @message.valid?
    @message.content = "t"*2001
    assert_not @message.valid?
  end
  
  test "title validity" do
    assert @message.valid?
    @message.title = ""
    assert_not @message.valid?
  end
  
  test "title length validity" do
    assert @message.valid?
    @message.title = "t"*101
    assert_not @message.valid?
  end
  
  test "sender validity" do
    assert @message.valid?
    @message.sender_id = nil
    assert_not @message.valid?
  end
  
  test "reciever validity" do
    assert @message.valid?
    @message.sender_id = nil
    assert_not @message.valid?
  end
  
  test "getting accounts" do
    assert_equal @first.sender,@steve
    assert_equal @second.sender,@mad
    assert_equal @first.reciever,@mad
    assert_equal @second.reciever,@steve
  end
  
  test "order should be most recent first" do
    assert_equal messages(:most_recent), Message.first
  end
  
end
