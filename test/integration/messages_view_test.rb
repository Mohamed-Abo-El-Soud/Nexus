require 'test_helper'

class MessagesViewTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    
    @accounts_6 = Account.order(:created_at).take(6)
    6.times do |n|
      title = Faker::Lorem.word
      content = Faker::Lorem.sentence(5)
      @accounts_6.each do |account|
        account.messages.create!(reciever_id: @accounts_6[5-n].id, title: title, content: content)
      end
    end
   
    @account = Account.order(:created_at).first
    
  end
  
  test "account is valid" do
    assert @account.valid?
  end
  
  test "messages number should be accurate" do
    log_in_as(@account)
    get account_path @account
    assert_template 'accounts/show'
    assert @account.messages.any?, 6
    # verify number
    assert_select '#messages-count', text: "Messages (#{@account.messages.count})"
    assert_select 'div.messages ul.collection'
    assert_select '#today-label' 
    @accounts_6.each do |account|
      assert account.messages.where(reciever_id: @account.id)
    end
    first_page_of_messages = @account.messages.paginate(page: 1)
    first_page_of_messages.each do |message|
      # message list
      assert_select 'b.title', text: message.title
      sender = Account.find(message.sender_id)
      assert_select "p", text: "#{sender.first_name} #{sender.last_name}"
      assert_select "p.truncate", text: message.content
      # message pop-up 
      assert_select ".modal#show-message-#{message.id}" 
      assert_select ".modal h4#title", text: message.title
      assert_select ".modal #sender", text: "#{sender.first_name} #{sender.last_name} (#{sender.email})"
      reciever = Account.find(message.reciever_id)
      assert_select ".modal #reciever", text: "to #{reciever.email}"
      assert_select ".modal #content", text: message.content
    end
  end
  
end
