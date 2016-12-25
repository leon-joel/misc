case p(42)
  when 0
    p(0)
  when 1
    p(1)
  else
    p("others")
end

# MinRubyでは if文のネスト に展開されるため、
# p(42)が2回呼び出される。

# Rubyとして実行した場合には p(42)は1回しか呼び出されない。