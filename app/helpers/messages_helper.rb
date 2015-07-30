module MessagesHelper
  
  # @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
  # #           'August', 'September', 'October', 'November', 'December']
  
  # @initialized = false
  # @times = [:now, :today,:yesterday,:july] 
  # @pieces = []
  
  def initialize_time_sort()
    
    @months = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
             'August', 'September', 'October', 'November', 'December']
    @initialized = false
    @times = [:now, :today,:yesterday,:july] 
    @pieces = []
    
    puts @times
    raise if @times.nil?
    @times[0] = [nil, Time.zone.now]
    @times[1] = ["Today", 1.days.ago]
    @times[2] = ["Yesterday", 2.days.ago]
    (3..14).each do |n|
      @times[n] = []
      @times[n][1] = (n-2).months.ago
      @times[n][0] = @months[@times[n][1].month]
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
  
  def get(collection, n)
    raise unless @initialized
    collection.where(created_at: @times[n+1][1]..@times[n][1])
  end
  
  def categorize(collection)
    index = 0
    item_range =collection.where(created_at: @times[index+1][1]..@times[index][1]) 
    while (index < 20) && item_range.count != 0 do
      raise if index == 19
      @pieces[index] = item_range
      item_range = collection.where(created_at: @times[index+1][1]..@times[index][1])
      index += 1
    end
  end
  
end
