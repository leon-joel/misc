# require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc

# 度数をカウント
def frequency(array)
  array.reduce({}) do |hash, element|
    # まだ要素が存在していない場合には0をセットしている
    hash[element] ||= 0
    # 度数をインクリメント
    hash[element] += 1
    hash
  end
end

a = [0, 1, 1, 2, 3, 3]
p h = frequency(a)


puts
puts "初期ハッシュにデフォルト値を与えておくことで、都度0をセットしておく必要がなくなった"
def frequency2(array)
  array.reduce(Hash.new(0)) do |hash, element|
    # 度数をインクリメント
    hash[element] += 1
    hash
  end
end

a = [0, 1, 1, 2, 3, 3]
p h = frequency(a)


puts <<-EOS.strip_heredoc

ハッシュのデフォルト値を空配列[]にしてみる ※問題あり
=============================================================
EOS

h = Hash.new([])
p h[:missing_key]     # -> []

p h[:missing_key] << "Hey there!" # -> ["Hey there!"]     # ★実はデフォルト値を変更してしまっている！！！

p h.keys              # -> []  ★上でセットしたはずなのに入っていない

p h[:missing_key]     # -> ["Hey there!"] ★ほら、デフォルト値が変わっている！

puts <<-EOS.strip_heredoc

存在しないキーにアクセスした時に、新しい空配列を作るようにする
============================================================
EOS

h = Hash.new { [] }   # ★ここがキモ！ ブロックを渡して、デフォルト値として毎回新しい[]を返すようにしている。

h[:weekdays] = h[:weekdays] << "Monday"

h[:months] = h[:months] << "January"

p h[:weekdays]    # -> ["Monday"]

p h[:holidays]    # -> []

p h.keys          # -> [:weekdays, :month]  ★holidaysが追加されていないことを確認

puts <<-EOS.strip_heredoc

もう少し進めて存在しないキーにアクセスされたら、要素を追加してしまうように実装できる ★問題あり
=========================================================
EOS

h = Hash.new { |hash, key| hash[key] = [] }

p h[:weekdays] << "Monday"

p h[:holidays]    # -> []

p h.keys          # -> [:weekdays, :holidays]   ★:holidaysも追加されてしまっている
                  # つまり、存在チェックのためにアクセスしただけでも要素が追加されてしまう、という問題がある

puts <<-EOS.strip_heredoc

ハッシュのデフォルト値がnilである事に依存するコードは書かないようにしよう
====================================================================================
EOS

puts "キーが存在したら… という処理にこういうif条件を書くのは危険"
if h[:birthdays]
  puts "もともとキーが存在していなかったはずなのに、アクセスした瞬間に[]が作られてしまった！！！"
end
p h.keys          # -> [:weekdays, :holidays, :birthdays]

puts
puts "存在チェックにはfetchを使おう！"
begin
  h.fetch(:sundays)   # -> key not found: :sundays (KeyError)
rescue KeyError => e
  p e
end
p h.keys          # -> [:weekdays, :holidays]  ★:sundaysが追加されていないことがわかる


puts <<-EOS.strip_heredoc

fetchでErrorが飛んでくるのは面倒なので、見つからなかった時の戻り値をカスタマイズできる
HashのコンストラクタでGlobalなデフォルト値を与えるよりは安全（な場合もある）
EOS

p h.fetch(:mondays, [])   # -> []

h[:fridays] = h.fetch(:fridays, []) << "Friday"

p h.keys          # -> [:weekdays, :holidays, :fridays]
