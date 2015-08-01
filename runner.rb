# include MessagesHelper

# @sorted = initialize_time_sort_2 Message.all

# @emptied = eliminate_empties @sorted

# @unduplicated = eliminate_duplicates @emptied

original = [{created_at: Time.new(2015,7,1),content:"today's content"},{created_at: Time.new(2015,6,30,3),content:"today's content"},{created_at: Time.new(2015,6,30,11),content:"last night's content"},{created_at: Time.new(2015,6,1),content:"few days back's content"}]

a = ["Today", {Time.new(2015,7,1) => ["today's content"]} ]
b = ["Yesterday", {Time.new(2015,6,30) => ["yesterday's content", "last night's content"] } ]
c = ["This Month", {Time.new(2015,6,1) => ["yesterday's content", "last night's content", "few days back's content"] } ]
puts "starting ...."
puts a
puts b
puts c
result = {}
b[1].each do |key, value|
  key_broad = key.beginning_of_month
  unless c[key_broad]
    result[key] = value
  end
end
b[0] = result
puts "ending ...."
puts a
puts b
puts c