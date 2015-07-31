include MessagesHelper

@sorted = initialize_time_sort_2 Message.all

@emptied = eliminate_empties @sorted

@unduplicated = eliminate_duplicates @emptied