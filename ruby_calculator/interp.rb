require "minruby"

def max(tree)
  if tree[0] == "lit"
    # 葉leafの場合は値を返すだけ
    return tree[1]
  end

  # 節treeの場合は左右それぞれで再帰呼び出しし、大きい方を返す
  left = max(tree[1])
  right = max(tree[2])
  [left, right].max
end

def evaluate(tree, env)
  if tree[0] == "lit"
    # 葉leafの場合は値を返すだけ
    return tree[1]

  elsif tree[0] == "func_call"
    # 例) ["func_call", "p", ["+", ["lit", 40], ["lit", 2]]]

    # 仮の実装 ※tree[1]に入っている関数名は無視して p を呼び出している
    return p(evaluate(tree[2], env))

  elsif tree[0] == "stmts"
    # 複文対応
    i = 1
    last = nil
    while tree[i] != nil
      last = evaluate(tree[i], env)
      i = i + 1
    end
    return last

  elsif tree[0] == "var_assign"
    #  ["var_assign", "x", ["lit", 1]],
    #  ["var_assign", "y", ["*", ["lit", 2], ["lit", 3]]]]
    return env[tree[1]] = evaluate(tree[2], env)

  elsif tree[0] == "var_ref"
    # ["stmts",
    #   ["var_assign", "x", ["lit", 1]],
    #   ["var_assign", "y", ["+", ["lit", 2], ["var_ref", "x"]]]]
    return env[tree[1]]
  end

  # 節treeの場合は左右それぞれで再帰呼び出し
  left = evaluate(tree[1], env)
  right = evaluate(tree[2], env)

  # 演算子で分岐
  case tree[0]
    when '+'
      # +演算子の実行回数をカウント ※第5回 練習問題2 http://ascii.jp/elem/000/001/264/1264148/
      env["plus_count"] += 1 if env.has_key?("plus_count")  # 演算結果を返さないと行けないので、countを先に行う

      left + right
    when '-'
      left - right
    when '*'
      left * right
    when '/'
      left / right
    when '%'  # 剰余
      left % right
    when '**' # 累乗
      left ** right

    when '=='
      left == right
    when '>'
      left > right
    when '>='
      left >= right
    when '<'
      left < right
    when '<='
      left <= right

    else
      puts 'unknown operator found!'
      pp tree
      raise "unknown_operator"
  end
end

####################################################################
###
### Main
###

if $0 == __FILE__
  # ① 計算式の文字列を読み込む
  str = minruby_load

  # ② 計算式の文字列を計算の木に変換する
  tree = minruby_parse(str)
  # pp tree

  # ③ 計算の木を実行（計算）する
  env = {}  # 環境（変数格納）用のhash
  answer = evaluate(tree, env)
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