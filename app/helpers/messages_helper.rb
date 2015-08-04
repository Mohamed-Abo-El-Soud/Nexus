module MessagesHelper
  
  def initialize_time_sort(collection, options = {})
    
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
      next if year == current_time.year
      order.push [year.to_s, year_group]
      collection = collection.reject {|n| year_group.include? n}
    end
    
    by_month = collection.group_by { |m| m.created_at.beginning_of_month }
    
    (1..(time_current_month_number-2)).each do |index|
      break if by_month[index].nil?
      order.push [@months[index], by_month[index]]  # => 4..?<16
      collection = collection.reject {|n| by_month[index].include? n}
    end
    
    unless by_month[time_last_month].nil?
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
      order.push ["This Month", by_month[current_month] ]  # => 2
    end
    
    unless by_day[time_yesterday].nil?
      order.push ["Yesterday", by_day[time_yesterday] ]  # => 1
    end
    
    unless by_day[time_today].nil?
      order.push ["Today", by_day[time_today] ]  # => 0
    end
    
    # collection = collection.reject {|n| by_month[current_month].include? n}
    
    return order.reverse
    
  end
     
  def timeago(time, tag = :abbr, options = {})
    options[:class] ||= "timeago"
    if tag == :none
      return time.to_s
    end
    content_tag(tag, time.to_s, options.merge(:title => time.getutc.iso8601)) if time
  end
  
  def slugger(input)
    input.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
  
  def display_time_sort(roster, options = {})
    result = []
    roster.each do |period|
      time = period[0]
      messages_period = period[1]
      label_color ||= 'grey lighten-2'
      label_text_color ||= 'grey-text text-darken-1'
      class_attr = "collection-item #{label_color} #{label_text_color}"
      result.push content_tag(:li, :id => "#{slugger time}-label", :class => class_attr) {
        concat content_tag :b, time
      }
      result.push content_tag(:div, :class => "card") {
        concat render messages_period, options
      }
      
    end
    return result.join().html_safe
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
  
end
