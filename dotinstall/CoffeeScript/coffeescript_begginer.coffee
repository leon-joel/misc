# comment -> JSには残らない
###
comment JSに残る
###

###
1. var不要
2. 行末 ; 不要
3. {} はインデントで表現する
4. () は省略可能
###

score = 82
if 80 < score
  alart "OK"

# バッククオートでJS埋め込み
`alert("hello");`


# string

# 式展開

score = 80
alert "score: " + score   # Javascript記法
alert "score: #{score}"
alert "score: #{score * 10}"


# 複数行
msg = "this
       is
  a very
 long
msg"

# heredoc

html = """
       <div id="main">
         hello
       </div>
       """

# array

a = [1, 3, 5]
b = [
  1
  3
  5
]

# ..

m = [0..5]
n = [0...5]

#alert m[1..3]  # インデックス番号1～3
#alert m[..3]   # 先頭から3
#alert m[1..]   # 1から最後まで
#alert m[..]    # 全部
alert m[1..-2] # 1から(最後-1)まで -> 1,2,3,4

# 0..1番目を置き換え
m[0..1] = ["a", "b", "c"]
alert m  # -> a, b, c, 2,3,4,5

# 文字列から抜き出し
alert "world"[1..3]

###
オブジェクト
###

# m = { name: "tata", score: 80}

# m = name: "tata", score: 80


m =
  name: "tata"
  score: 80


n =
  name: "fff"
  score:
    first: 80
    second: 70
    third: 90


# if : どの書き方も同じ意味

if 60 < score
  alert score

if score > 60 then alert score

alert score if 60 < score

# if else
if 60 < score
  alert "OK"
else
  alert "NG"

if 60 < score then alert "OK" else alert "NG"


# 3項演算子 condition ? a : b は使えないので… if式を使う
msg = if 60 < score then "OK" else "NG"


# 比較演算子

# == -> === is
# != -> !== isnt

# 比較演算子の連結
alert "ok" if 10 < x < 20

# 真偽値
# true  -> yes on
# false -> no off

# 論理演算子
# && -> and
# || -> or
# !  -> not

alert "OK" if answer is yes and signal isnt off

# 配列内に存在？
alert "OK" if 5 in [1, 3, 5]

# オブジェクト内に存在？
obj =
  score: 52
alert "OK" if score of obj

# switch

### Javascriptの場合
switch (signal) {
  case "red":
    alert("STOP!");
    break;
  case "blue":
  case "green":
    alert("GO!");
    break;
  case "yellow":
    alert("CAUTION!");
    break;
  default:
    alert("wrong signal!");
}
###

# coffeescriptならこんなにスッキリ書ける
switch signal
  when "red"
    alert "STOP!"
  when "blue", "green" then alert "GO!"
  when "yellow" then alert "CAUTION!"
  else alert "wrong signal!"

# for

###
# 基本的な書き方
sum = 0
for i in [0..9]
  sum += i
alert sum

# ループの中身を前に出す書き方も出来る
sum = 0
sum += i for i in [0..9]
alert sum

# インクリメントする数を2にする
sum = 0
sum += i for i in [0..9] by 2
alert sum

# 配列内包
sum = 0
total = (sum += i for i in [0..9])
alert total # totalには配列が格納されている
###

# while文
i = 0
sum = 0
total = while i < 10
  sum += i
  i++
alert sum
alert total  # ループ内で最後に評価した値が配列として格納されている

# array

###
for color in ["red", "blue", "pink"]
  alert color

# forと同様、ループの中身を前に出すことも出来る
alert color for color in ["red", "blue", "pink"]

# 配列の後ろに条件を入れることも出来る
alert color for color in ["red", "blue", "pink"] when color isnt "blue"

# 配列のインデックスも同時に取得（0始まり）
alert "#{i}: #{color}" for color, i in ["red", "blue", "pink"]
###

# objectの中身を列挙して処理
results =
  taguchi: 40
  fkoji: 80
  dotintstall: 60

for name, score of results
  alert "#{name}: #{score}"

# やはりループの中身を前に出すことも可能
alert "#{name}: #{score}" for name, score of results


# function

### javascriptの書き方
function hello() {}
var hello = function() {}
###

### coffeescriptでの関数
# 基本の書き方
hello = -> alert "hello"
# 呼び出し方（引数がないときは()が必要）
hello()

# 引数有り
hello = (name) -> alert "hello #{name}"
hello "taguchi"

# 引数有り（引数のデフォルト値あり）
hello = (name = "taguchi") -> alert "hello #{name}"
hello()

# 関数の戻り値 ※最後に評価された値が返却される
hello = -> "hello"
msg = hello()
alert msg
###

# 関数の戻り値 ※最後に評価された値が返却される
hello = -> "hello"
msg = hello()
alert msg

###即時関数
(function() {
  alert "hello"
})();
###

do -> alert "hello"


# 分割代入

[a, b, c] = [1, 5, 10]

x = 10
y - 20

# 値の入れ替えを簡単に記述
[x, y] = [y, x]

# 関数の戻り値を複数に
pows = (x) -> [x, x**2, x**3]
[a, b, c] = pows 5


# オブジェクトから複数の値を取り出す
user =
  name: "tttt"
  score: 52
  email: "tttt@dot.com"

{name, email} = user

# Class

###
# 標準的な記法
class User
  constructor: (name) ->
    # this.name = name
    @name = name
###

# 簡略化した記法
class User
  # @name = name と同じ意味
  constructor: (@name) ->
  # メソッド定義
  hello: -> alert "hello, #{@name}"

tom = new User "ttt"
alert tom.name
tom.hello()



# 継承
class AdminUser extends User
  # メソッドオーバーライド
  hello: ->
    alert "admin says..."
    super()

tom = new User "ttt"
#alert tom.name
#tom.hello()

bob = new AdminUser "bob"
#alert bob.name
bob.hello()


# 存在演算子 ?

# Javascriptの場合は
# 0 ''  -> falseと判定される

# x = "10"
rs = if x? then "found" else "not found"
alert rs

# 二項演算子としての ?

y = 10
x = y ? 20
alert x


# 安全なアクセス演算子

user =
  name: "ttt"
alert user.score?.first  # プロパティ
alert user.sayhi?()      # 関数