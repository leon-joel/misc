case 42
  when 0
    p(0)
  when 1
    p(1)
  else
    p(2)
end

# case文はif文に展開されるシンタックスシュガー
# ["if",
#  ["==", ["lit", 42], ["lit", 0]],
#  ["func_call", "p", ["lit", 0]],
#  ["if",
#   ["==", ["lit", 42], ["lit", 1]],
#   ["func_call", "p", ["lit", 1]],
#   ["func_call", "p", ["lit", 2]]]]
