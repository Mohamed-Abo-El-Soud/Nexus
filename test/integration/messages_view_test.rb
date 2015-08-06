require 'test_helper'

include MessagesHelper

class MessagesViewTest < ActionDispatch::IntegrationTest
  
  def setup
    
   # @accounts_6 = Account.order(:created_at).take(6)
    
    # 6.times do |n|
    #   title = Faker::Lorem.word
    #   content = Faker::Lorem.sentence(5)
    #   @accounts_6.each do |account|
    #     index += 1
    #     message = account.messages.create!(reciever_id: @accounts_6[5-n].id, title: title,
    #                             content: content, created_at: index.days.ago)
    #   end
    # end
    
    @account = Account.order(:created_at).first
    
    # 20.times.do |n|
    #   title = "test"
    #   content = Faker::Lorem.sentence(5)
    #   @ccount.messages.create!(reciever_id: 1, title: title,
    #                             content: content, created_at: n.days.ago)
    # end
    
    
    # initialize_time_sort
  end
  
  test "account is valid" do
    assert @account.valid?
  end
  
  test "messages view should be accurate" do
    
    6.times do |n|
      @account.messages.create!(reciever_id: accounts(:steve).id,
                                title: "test-view",
                                content: Faker::Lorem.sentence(5))
    end
    
    log_in_as(@account)
    get account_path @account
    assert_template 'accounts/show'
    assert @account.messages.any?
    assert_equal @account.messages.count , 6 #supposed to be assert, not assert_not
    # verify number
    assert_select '#messages-count', text: "Messages (#{@account.messages.count})"
    assert_select 'div.messages ul.collection'
    assert_select '#today-label' 
    # @accounts_6.each do |account|
    #   assert account.messages.where(reciever_id: @account.id)
    # end
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
#=begin
  test "time_sort: group_by functionality works" do
   
    current_time = Time.new(2015,7,2).beginning_of_day
    
    5.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-group_by",
                                content: Faker::Lorem.sentence(5),
                                created_at: current_time + n.seconds)
    end
    
    3.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-group_by",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.day) + n.seconds)
    end
    
    4.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-group_by",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.month) + n.seconds)
    end
    
    messages = Message.where title: "test-group_by"
    
    by_day = messages.group_by { |m| m.created_at.beginning_of_day }
    by_month = messages.group_by { |m| m.created_at.beginning_of_month }
    by_year = messages.group_by { |m| m.created_at.beginning_of_year }
    
    assert_equal by_day.count, 3
    assert_equal by_month.count, 2
    assert_equal by_year.count, 1
  end
  
  test "time_sort: prior elimination and sorting functionality works" do
    
    current_time = Time.new(2015,7,1,4)#.beginning_of_day
    
    beginning_of_day = current_time.beginning_of_day
    
    time_today = beginning_of_day
    time_yesterday = (beginning_of_day - 1.days)
    time_last_month = (beginning_of_day - 1.months).beginning_of_month
    
    mes_1 = {created_at: Time.new(2015,7,1,8),content:"today's content"}
    mes_2 = {created_at: Time.new(2015,6,30,3),content:"yesterday's content"}
    mes_3 = {created_at: Time.new(2015,6,30,11),content:"last night's content"}
    mes_4 = {created_at: Time.new(2015,6,1,10),content:"few days back's content"}
    
    original = [mes_1, mes_2, mes_3, mes_4]
    
    a = ["Today", {Time.new(2015,7,1) => [mes_1]} ]
    b = ["Yesterday", {Time.new(2015,6,30) => [mes_2, mes_3] } ]
    c = ["Last Month", {Time.new(2015,6,1) => [mes_2, mes_3, mes_4] } ]
    
    b_last = ["Yesterday", {}]
    
    by_day = original.group_by { |m|   m[:created_at].beginning_of_day }
    by_month = original.group_by { |m| m[:created_at].beginning_of_month }
    
    a_sorted = ["Today", time_today => by_day[time_today] ]  # => 0
    b_sorted = ["Yesterday", time_yesterday => by_day[time_yesterday] ]  # => 1
    c_sorted = ["Last Month", time_last_month => by_month[time_last_month] ]  # => 2
    assert_equal a,a_sorted
    assert_equal b,b_sorted
    assert_equal c,c_sorted
    
    # puts by_month[time_last_month]
    # puts "and"
    # puts c
    
    result = {}
    b_sorted[1].each do |key, value|
      # puts key.beginning_of_month
      # # puts time_last_month == key.beginning_of_month
      # puts c[1]#[time_last_month]
      # puts c[1][key.beginning_of_month]
      key_broad = key.beginning_of_month
      unless c[1][key_broad]
        result[key] = value
      end
    end
    b_sorted[1] = result
    
    
    
    assert_equal b_sorted,b_last
    
  end
  
#=end  
  test "time_sort: should provide accurate information" do
   
    current_time = Time.new(2015,7,2).beginning_of_day
    
    5.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-accurate",
                                content: Faker::Lorem.sentence(5),
                                created_at: current_time + n.seconds)
    end
    
    3.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-accurate",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.day) + n.seconds)
    end
    
    4.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-accurate",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.month) + n.seconds)
    end
    
    messages = Message.where title: "test-accurate"
    
    assert_equal messages.where(created_at: current_time...(current_time + 1.day)).count, 5
    assert_equal messages.where(created_at: (current_time - 1.day)...current_time).count, 3
    assert_equal messages.where(created_at: (current_time - 1.month)...(current_time - 1.day)).count, 4
    
    assert messages.any?
    
    assert_equal messages.count, 12
    
    roster = initialize_time_sort messages, current_time: current_time
    
    assert_not_nil roster
    # puts "hey!!"
    # puts roster
    # roster.each do |item|
    #   puts item[0]
    # end
    # puts "hey!!"
    assert_equal roster.count, 3
    assert_equal roster[0][0] , "Today"
    assert_equal roster[1][0] , "Yesterday"
    assert_equal roster[2][0] , "Last Month"
    
    assert roster[0][1]
    assert roster[1][1]
    assert roster[2][1]
    
    assert_equal roster[0][1].count, 5
    assert_equal roster[1][1].count, 3
    assert_equal roster[2][1].count, 4
  end
  
  test "time_sort: when today is the beginning of the month, the day before should be last month and not yesterday" do
    current_time = Time.new(2015,7,1)
    
    6.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-last-month",
                                content: Faker::Lorem.sentence(5),
                                created_at: current_time.beginning_of_day + n.seconds)
    end
    
    8.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-last-month",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.day).beginning_of_day + n.seconds)
    end
    
    messages = Message.where title: "test-last-month"
    
    assert messages.any?
    
    # assert_equal messages.count, 14
    
    roster = initialize_time_sort messages, current_time: current_time
    
    # puts roster
    
    assert_equal roster.count, 2
    assert_equal roster[0][0], "Today"
    assert_equal roster[1][0], "Last Month"
    assert_equal roster[0][1].count, 6
    assert_equal roster[1][1].count, 8
    
  end
  
  test "time_sort: when today is the beginning of the year, the day before should be Year and not yesterday or last month" do
    current_time = Time.new(2015,1,1)
    
    7.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-last-year",
                                content: Faker::Lorem.sentence(5),
                                created_at: current_time.beginning_of_day + n.seconds)
    end
    
    3.times do |n|
      @account.messages.create!(reciever_id: 1,
                                title: "test-last-year",
                                content: Faker::Lorem.sentence(5),
                                created_at: (current_time - 1.day).beginning_of_day + n.seconds)
    end
    
    messages = Message.where title: "test-last-year"
    
    assert messages.any?
    
    assert_equal messages.count, 10
    
    roster = initialize_time_sort messages, current_time: current_time
    
    assert_equal roster.count, 2
    assert_equal roster[0][0], "Today"
    assert_equal roster[1][0], "2014"
    assert_equal roster[0][1].count, 7
    assert_equal roster[1][1].count, 3
    
  end
  
end