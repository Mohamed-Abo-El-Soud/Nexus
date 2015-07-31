module MessagesHelper
  
  def initialize_time_sort
    #   ORDER:
    # today: now -> now.beginning_of_day
    # yesterday: now.beginning_of_day -> yesterday.beginning_of_day
    # this month: yesterday.beginning_of_day -> now.beginning_of_month 
    # last month: 0.months.ago.beginning_of_month  (July) -> 1.months.ago.beginning_of_month  (June)
    # . May 1
    # . April 2
    # . March 3
    # . Feb 4
    # January: 5.months.ago.beginning_of_month (Feb) -> 6.months.ago.beginning_of_day (Jan)
    # last year: now.beginning_of_year -> 1.years.ago.beginning_of_year
    # YEAR X (eg: 2012): 2.years.ago.beginning_of_year (2013) -> 3.years.ago.beginning_of_year (2012)
    
    
    
    @months = [nil, 'January', 'February', 'March', 'April', 'May', 'June', 'July',
             'August', 'September', 'October', 'November', 'December']
    @initialized = false
    @times = [] 
    @time_names = ["Today", "Yesterday", "This Month", "Last Month"]
    @pieces = []
    
    @times[0] = ["Today", Time.zone.now..Time.zone.now.beginning_of_day]
    @times[1] = ["Yesterday", Time.zone.now.beginning_of_day..1.days.ago.beginning_of_day]
    @times[2] = ["This Month", 1.days.ago.beginning_of_day..Time.zone.now.beginning_of_month]
    @times[3] = ["Last Month", Time.zone.now.beginning_of_month..1.months.ago.beginning_of_day]
    (4..14).each do |n|
      # @times[n] = []
      @times[n] = (n-2).months.ago.beginning_of_day
      @time_names[n-1] = @months[@times[n].month]
    end
    @times[15] = ["This Year", 1.years.ago]
    def @times.[](i)
      fetch(i) do 
        t = (i-14).years.ago
        [t.year,t]
      end
    end
    @initialized = true
  end
  
  def initialize_time_sort_2(collection)
    @months = [nil, 'January', 'February', 'March', 'April', 'May', 'June', 'July',
             'August', 'September', 'October', 'November', 'December']
    
    time_today = Time.now.beginning_of_day
    time_yesterday = 1.days.ago.beginning_of_day
    time_current_month_number = time_today.month.to_i
    current_month = Time.now.beginning_of_month
    time_last_month = 1.months.ago.beginning_of_month
    
    by_day = collection.group_by { |m| m.created_at.beginning_of_day }
    by_month = collection.group_by { |m| m.created_at.beginning_of_month }
    by_year = collection.group_by { |m| m.created_at.beginning_of_year }
    
    order = []
    order[0] = ["Today", by_day[time_today] ]  # => 0
    order[1] = ["Yesterday", by_day[time_yesterday] ]  # => 1
    order[2] = ["This Month", by_month[current_month] ]  # => 2
    order[3] = ["Last Month", by_month[time_last_month] ]  # => 3
    
    (1..(time_current_month_number-2)).to_a.reverse.each do |index|
      order.push [@months[index], by_month[index]]  # => 4..?<16
    end
    
    by_year.each_with_index do |item, index|
      break unless index > 0
      order.push [index.years.ago.year, by_year[index]]
    end
    
    return order
    
  end
  
  def eliminate_empties(order)
    result = []
    order.each do |period|
      result.push period unless period[1].nil?
    end
    result
  end
  
  def eliminate_duplicates(order)
    raise unless order.class == Array
    order.to_a.reverse.each_with_index do |n, index|
      break if order[index+1].nil?
      future = order[index+1]
      past = order[index]
      future.each do |item|
        past.delete item
      end
    end
    order
  end
  
      
=begin

  messages representation:
          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
  DAYS    |t | y|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
          |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
          |     |     |     |     |     |     |     |     |     |     |     |
          | tm  |lm   |     |     |     |     |     |     |     |     |     |
  MONTHS  |     |     |     |     |     |     |     |     |     |     |     |
          |     |     |     |     |     |     |     |     |     |     |     |
          |     |     |     |     |     |     |     |     |     |     |     |      
          |                       |                       |                 
  YEARS   |                       |          2014         |          2013       
          |                       |                       |                 
          |                       |                       |                 
          |                       |                       |            
  
=end
  
  def categorize(collection)
    raise unless @initialized
    index = 0 
    while index < 20 do
      raise if index == 19
      item_range = collection.where(created_at: @times[index+1][1]..@times[index][1])
      break if item_range.count == 0
      @pieces[index] = item_range
      index += 1
    end
  end
  
end
