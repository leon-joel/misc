def event(description)
  # blockでイベント発火条件が与えられ、
  # それを満たしていたらALERTが出力される。
  puts "ALERT: #{description}" if yield
end

load 'events.rb'