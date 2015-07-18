require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  def setup
    @first = messages(:steve_mail)
    @second = messages(:max_mail)
    @steve = accounts(:steve)
    @mad = accounts(:mad)
  end
  
  test "content length validity" do
    assert @first.valid?
    @first.content = "t"*2001
    assert_not @first.valid?
  end
  
  test "title validity" do
    assert @first.valid?
    @first.title = ""
    assert_not @first.valid?
  end
  
  test "title length validity" do
    assert @first.valid?
    @first.title = "t"*101
    assert_not @first.valid?
  end
  
  test "sender validity" do
    assert @first.valid?
    @first.sender_id = nil
    assert_not @first.valid?
  end
  
  test "reciever validity" do
    assert @first.valid?
    @first.sender_id = nil
    assert_not @first.valid?
  end
  
  test "getting accounts" do
    assert_equal @first.sender,@steve
    assert_equal @second.sender,@mad
    assert_equal @first.reciever,@mad
    assert_equal @second.reciever,@steve
  end
end
