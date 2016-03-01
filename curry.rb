#! /usr/local/bin/ruby -E Windows-31J:utf-8
# coding: utf-8

# frozen_string_literal: true
# 上はruby2.3から導入される、文字列リテラルのデフォルトfreeze化マジックコメント ※ruby2.2では無視される

####################################################################################################
# ruby起動引数: -E default_external:default_internal
#    デフォルトの外部エンコーディングと内部エンコーディングを指定している。
# マジックコメント: coding: スクリプト自体のエンコーディング ※この部分は encoding でもOK



### frozenのテスト
p "test".frozen?    # -> false : ruby2.2の場合

sql = "SELECT * FROM test "
# sql = "SELECT * FROM test ".freeze
sql << " WHERE name = 'tanaka';"    #  ↑の行で.freezeを付けると、ここでエラーが発生 can't modify frozen String (RuntimeError)
                                    # ruby2.3でマジックコメントを付けた場合 or ruby3.0以降 では、freezeを明記しなくてもエラーになるはず。
p sql




puts '##### curryのテスト #####'
# 2引数を取る関数を準備する ※lambdaじゃなくても出来るけどまずlambdaで
func = -> x, y { x + y }
p func
# 呼び出し方3種類
puts func.(2,3)
puts func.call(2,3)
puts func[2, 3]

# カリー化する
curried = func.curry
p curried   # -> Proc

# 部分適用する （＝オリジナルの第1引数に2を入れた関数を生成）
c2 = curried.call(2)
p c2        # -> Proc

# 結果を出す（＝オリジナルの第2引数に3を入れて結果を受け取る）
p c2.call(3)

puts '##### 3引数の実験 #####'
# 3引数を取る関数を準備する
def method3(x, y, z)
  result = x * y * z
  puts "結果: #{result}"
  return result
end
# p method3   # Procじゃないからこれはエラーになる

# curry化できるようにProc化する
func3 = method(:method3)                      # Methodに変換 ☆ruby2.2以降、Methodもcurry化できるようになったのでこちらでOK
# func3 = -> (x, y, z) { method3(x, y, z) }   # ruby2.1以前はProc化しないといけないようだ

p func3     # -> Method or Proc

# curry化する
curried_func3 = func3.curry
p curried_func3 # -> Proc

# 部分適用（引数1を1に固定）
f1 = curried_func3.call(1)
p f1            # -> Proc

# 部分適用（引数2を2に固定）
f2 = f1.call(2)
p f2            # -> Proc

# 結果を出す（引数3に3を入れてmethodを呼び出す）
f2.call(3)      # -> 6


puts '2引数を同時に渡して部分適用する'
ff2 = curried_func3.call(1, 2)
p ff2
ff2.call(3)

puts '違う書き方で'
fff2 = curried_func3[2][3]
p fff2    # -> Proc
fff2[4]

puts 'いきなり結果を出すところまで実行'
curried_func3[1][3][5]  # 計算結果が出力される ※つまり、引数の数によって Proc が返ってくるか、計算結果が返されるかが変わる