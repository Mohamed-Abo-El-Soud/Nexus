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
  
  def initialize_time_sort_2(collection, options = {})
    
    current_time = options[:current_time] || Time.now
    beginning_of_day = current_time.beginning_of_day
    
    @months = [nil, 'January', 'February', 'March', 'April', 'May', 'June', 'July',
             'August', 'September', 'October', 'November', 'December']
    
    time_today = beginning_of_day
    time_yesterday = (beginning_of_day - 1.days)
    time_current_month_number = time_today.month.to_i
    current_month = beginning_of_day.beginning_of_month
    time_last_month = (beginning_of_day - 1.months).beginning_of_month
    
    
    order = []
    
    by_year = collection.group_by { |m| m.created_at.beginning_of_year }
    
    by_year.each do |key, year_group|
      year = key.year
      time_year = Time.new(year).beginning_of_year
      break if year == current_time.year
      # order.push [year, time_year: year_group]
      order.push [year, year_group]
      collection = collection.reject {|n| year_group.include? n}
    end
    
    by_month = collection.group_by { |m| m.created_at.beginning_of_month }
    
    (1..(time_current_month_number-2)).each do |index|
      break if by_month[index].nil?
      order.push [@months[index], by_month[index]]  # => 4..?<16
      collection = collection.reject {|n| by_month[index].include? n}
    end
    
    # puts time_last_month
    # puts current_month
    unless by_month[time_last_month].nil?
      # order.push ["Last Month", time_last_month: by_month[time_last_month] ]  # => 3
      order.push ["Last Month", by_month[time_last_month] ]  # => 3
      collection = collection.reject {|n| by_month[time_last_month].include? n}
    end
    
    by_day = collection.group_by { |m| m.created_at.beginning_of_day }
    
    unless by_day[time_yesterday].nil?
      collection = collection.reject {|n| by_day[time_yesterday].include? n}
    end
    
    unless by_day[time_today].nil?
      collection = collection.reject {|n| by_day[time_today].include? n}
    end
    
    # a second time to eliminate all entries from today and yesterday
    by_month = collection.group_by { |m| m.created_at.beginning_of_month }
    unless by_month[current_month].nil?
      # order.push ["This Month", current_month: by_month[current_month] ]  # => 2
      order.push ["This Month", by_month[current_month] ]  # => 2
    end
    
    unless by_day[time_yesterday].nil?
      # order.push ["Yesterday", time_yesterday: by_day[time_yesterday] ]  # => 1
      order.push ["Yesterday", by_day[time_yesterday] ]  # => 1
    end
    
    unless by_day[time_today].nil?
      # order.push ["Today", time_today: by_day[time_today] ]  # => 0
      order.push ["Today", by_day[time_today] ]  # => 0
    end
    
    # collection = collection.reject {|n| by_month[current_month].include? n}
    
    
    # by_year.each_with_index do |item, index|
    #   break unless index > 0
    #   order.push [(beginning_of_day - index.years).year, by_year[index]]
    # end
    
    
    return order.reverse #eliminate_duplicates eliminate_empties order
    
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
  
  def eliminate_duplicates2(order)
    raise unless order.class == Array
    index = 0
    # order.to_a.reverse.each_with_index do |n, index|
    while true
      # break if order[index+1].nil?
      # future = order[index+1]
      # past = order[index]
      # future.each do |item|
      #   past.delete item
      # end
      
      max = n
      next_one = order[index+1]
      
      break if max[1].nil? || next_one[1].nil?
      break unless next_one[1].count != 0
      
      unless remove_once max, next_one
        max = next_one
      # beginning = get_beginning_function max
      # keys = []
      # next_one.keys.each do |key|
      #   unless max[
      end
      
    end
    order
  end
  
  def remove_once(first,second)
    beginning = get_beginning_function max
    second.keys.each do |key|
      unless first[key].nil?
        return true
      end
    end
    return false
  end
  
  def one_removes_another(first, second, type)
    beginning = case type
                  when :month
                  "beginning_of_month"
                  when :year
                  "beginning_of_year"
                end
                
    # beginning
    
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
