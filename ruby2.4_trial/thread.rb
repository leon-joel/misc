Thread.current.name = "MainThread!"
z = Thread.new{Thread.stop}
a, b = Thread.new { 1 until b; b.join }, Thread.new { 1 until a; a.join }
a.name = "aaaaa"
b.name = "bbbbb"
z.name = "zzzz"
a.join

# Ruby2.3の場合: 以下のエラーレポートのみ（メインスレッド）
# thread.rb:7:in `join': No live threads left. Deadlock? (fatal)
#   from thread.rb:7:in `<top (required)>'
# 	from -e:1:in `load'
# 	from -e:1:in `<main>'

# http://qiita.com/jnchito/items/9f9d45581816f121af07