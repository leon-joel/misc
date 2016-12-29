require "minruby"

require_relative "interp_builtin_methods"

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


def evaluate(tree, genv, lenv)
  return nil if tree.nil?   # これがあることでelseのないif文に対応できる

  if tree[0] == "lit"
    # 葉leafの場合は値を返すだけ
    return tree[1]

  elsif tree[0] == "var_assign"
    #  ["var_assign", "x", ["lit", 1]],
    #  ["var_assign", "y", ["*", ["lit", 2], ["lit", 3]]]]
    return lenv[tree[1]] = evaluate(tree[2], genv, lenv)

  elsif tree[0] == "var_ref"
    # ["stmts",
    #   ["var_assign", "x", ["lit", 1]],
    #   ["var_assign", "y", ["+", ["lit", 2], ["var_ref", "x"]]]]
    return lenv[tree[1]]

  elsif tree[0] == "func_def"
    # ["func_def", "add", ["x", "y"], ["+", ["var_ref", "x"], ["var_ref", "y"]]]
    genv[tree[1]] = ["user_defined", tree[2], tree[3]]
    # 関数名 => ["user_defined", 仮引数名の配列, 関数本体]
    return

  elsif tree[0] == "func_call"
    # 例) ["func_call", "p", ["+", ["lit", 40], ["lit", 2]]]

    # 仮の実装 ※tree[1]に入っている関数名は無視して p を呼び出している
    # return p(evaluate(tree[2], genv, lenv))

    # 関数に渡す引数を配列に入れていく
    args = []
    i = 0
    while tree[i + 2]
      args << evaluate(tree[i + 2], genv, lenv)
      i += 1
    end

    # 呼び出すべき関数配列を取得
    # genv = { 《関数名》 => ["builtin", 《本物のRubyにおける関数の名前》] }
    mhd = genv[tree[1]]

    if mhd[0] == "builtin"
      # 組み込み関数
      return minruby_call(mhd[1], args)
    else
      # ユーザー定義関数
      new_lenv = {}     # 関数内の環境（変数）
      params = mhd[1]   # 仮引数の配列 ※仮引数: 実引数に与えられた[関数内部での名前]
      i = 0
      while params[i]
        new_lenv[params[i]] = args[i]   # 仮引数の名前 => 実引数（の値）
        i += 1
      end
      return evaluate(mhd[2], genv, new_lenv)  # 関数本体
    end

  elsif tree[0] == "if"
    if evaluate(tree[1], genv, lenv)
      return evaluate(tree[2], genv, lenv)
    else
      return evaluate(tree[3], genv, lenv)
    end

  elsif tree[0] == "while"
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
    return  # rubyのwhile文はnilを返すのでMinRubyもそれに倣ってみる

  elsif tree[0] == "while2"
    # begin - end while (xxx) のパターン ※rubyでいうところの while 修飾子 ※Rubyではnilを返す
    # ※rubyのbegin-end whileをそのまま使っても面白くないので、while文を使って実装する
    evaluate(tree[2], genv, lenv)        # まずは無条件で tree[2] を実行
    while evaluate(tree[1], genv, lenv)  # 次に条件を判定して
      evaluate(tree[2], genv, lenv)      # 条件に合致していれば tree[2] を実行する
    end
    return  # rubyのwhile修飾子（式）はnilを返すのでMinRubyもそれに倣ってみる

  elsif tree[0] == "stmts"
    # 複文対応
    i = 1
    last = nil
    while tree[i] != nil
      last = evaluate(tree[i], genv, lenv)
      i = i + 1
    end
    return last

  end

  # 以下は全て二項演算子

  # 左右それぞれを評価 ※本当は演算子で分岐したあとで left/right を評価したいところだが、現時点ではこのままでよしとする
  left = evaluate(tree[1], genv, lenv)
  right = evaluate(tree[2], genv, lenv)

  # 演算子で分岐
  case tree[0]
    when '+'
      # +演算子の実行回数をカウント ※第5回 練習問題2 http://ascii.jp/elem/000/001/264/1264148/
      lenv["plus_count"] += 1 if lenv.has_key?("plus_count")  # 演算結果を返さないと行けないので、countを先に行う

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

# 関数格納用のhashを返す
def prepare_genv
  {
      "p" => ["builtin", "p"],
      "add" => ["builtin", "add"],
      "raise" => ["builtin", "raise"],

      "fizzbuzz" => ["builtin", "fizzbuzz"],
  }
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
  pp tree

  # ③ 計算の木を実行（計算）する
  answer = evaluate(tree, prepare_genv, {} )
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
