require "minruby"

def evaluate(tree)
  if tree[0] == "lit"
    # 葉leafの場合は値を返すだけ
    return tree[1]
  end

  # 節treeの場合は左右それぞれで再帰呼び出し
  left = evaluate(tree[1])
  right = evaluate(tree[2])

  # 演算子で分岐
  case tree[0]
    when '+'
      left + right
    when '-'
      left - right
    when '*'
      left * right
    # when '/'
    else
      left / right
  end
end

####################################################################
###
### Main
###

if $0 == __FILE__
  # ① 計算式の文字列を読み込む
  str = gets

  # ② 計算式の文字列を計算の木に変換する
  tree = minruby_parse(str)

  # ③ 計算の木を実行（計算）する
  answer = evaluate(tree)

  # ④ 計算結果を出力する
  p(answer)
end


# tree = minruby_parse("(1 + 2) + (3 + 4)")
# # pp tree
# answer = evaluate(tree)
# p(answer) #=> 10
#
# tree = minruby_parse("(1 * 2) * (3 + 4)")
# pp tree
# answer = evaluate(tree)
# p(answer) #=> 14
#
# tree = minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")
# pp tree
# answer = evaluate(tree)
# p(answer) #=> 100
