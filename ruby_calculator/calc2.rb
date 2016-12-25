answer = (1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)
p(answer)

# 構文解析した結果
# ["stmts",
#  ["var_assign",
#   "answer",
#   ["*",
#    ["*", ["/", ["+", ["lit", 1], ["lit", 2]], ["lit", 3]], ["lit", 4]],
#    ["+", ["+", ["/", ["lit", 56], ["lit", 7]], ["lit", 8]], ["lit", 9]]]],
#  ["func_call", "p", ["var_ref", "answer"]]]
