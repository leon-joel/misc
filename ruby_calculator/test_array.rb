ary = [1,2,3,4,6*7]
p ary[4]
p ary[0]
p ary[5-2]

ary = [1]
p( ary[0] = 42 )
# ["stmts",
#   ["var_assign", "ary", ["ary_new", ["lit", 1]]],
#   ["ary_assign", ["var_ref", "ary"], ["lit", 0], ["lit", 42]]]

p ary


48/180
11/60