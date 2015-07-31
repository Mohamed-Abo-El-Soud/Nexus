require 'test_helper'

include MessagesHelper

class MessagesViewTest < ActionDispatch::IntegrationTest
  
  def setup
    
    @accounts_6 = Account.order(:created_at).take(6)
    
    index = 0
    6.times do |n|
      title = Faker::Lorem.word
      content = Faker::Lorem.sentence(5)
      @accounts_6.each do |account|
        index += 1
        message = account.messages.create!(reciever_id: @accounts_6[5-n].id, title: title,
                                 content: content, created_at: index.days.ago)
      end
    end
   
    @account = Account.order(:created_at).first
    initialize_time_sort
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
      assert_select ".modal #sender b.tooltipped[data-tooltip=?]", sender.email,
                    text: "#{sender.first_name} #{sender.last_name}"
      reciever = Account.find(message.reciever_id)
      assert_select ".modal #reciever b.tooltipped[data-tooltip=?]", reciever.email,
                    text: "#{reciever.first_name}"
      assert_select ".modal #content", text: message.content
    end
  end
  
  test "time_sort should provide accurate information" do
    now = Time.zone.now
    today = 1.days.ago
    yesterday = 2.days.ago
    this_month = 1.months.ago
    20_years_ago = 20.years.ago
    
    assert (@times[0][1] - now) < 2
    assert (@times[1][1] - today) < 2
    assert (@times[2][1] - yesterday) < 2
    assert (@times[3][1] - this_month) < 2
    assert (@times[34][1] - 20_years_ago) < 2
  end
  
  test "first message created must be at least a month old" do
    this_month = 1.months.ago
    message = Message.last
    assert message.created_at.to_time < this_month
  end
  
  test "time_sort categorize should effectively categorize the messages into 3 parts" do
    messages = Message.all
    categorize messages
    now = Time.zone.now
    today = 1.days.ago
    yesterday = 2.days.ago
    this_month = 1.months.ago
    last_month = 2.months.ago
    assert @pieces[0].count
    assert @pieces[0] == messages.where(created_at: now..today)
    assert @pieces[1].count
    assert @pieces[1] == messages.where(created_at: today..yesterday)
    assert @pieces[2].count
    assert @pieces[2] == messages.where(created_at: now..today)
  
end
