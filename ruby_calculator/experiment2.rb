require "minruby"
pp(minruby_parse("
x = 1
y = 2 * 3
"))

# ["stmts",
#  ["var_assign", "x", ["lit", 1]],
#  ["var_assign", "y", ["*", ["lit", 2], ["lit", 3]]]]
