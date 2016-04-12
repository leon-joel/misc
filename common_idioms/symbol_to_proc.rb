require 'active_support/core_ext/string/strip'


names = ['bob', 'bill', 'heather']
p names.map {|name| name.capitalize }
p names.map {|name| name.upcase }

puts <<-EOS

こんな単純な関数呼び出しのために、
いちいちブロックを作ったりしたくない！もっと簡単に書きたい！

ワンコールブロックを &修飾（Symbol#to_procを呼び出してprocに変換） を使って書き換える。
※ruby1.8.7以降。それ以前はActiveSupportで定義されていた。
http://www.xmisao.com/2014/02/09/ruby-array-map-idiom-symbol-to-proc.html
EOS

p names.map(&:capitalize)
p names.map(&:upcase)


puts
puts <<-EOS.strip_heredoc

ついでに、reduce(inject)/each_with_object も試してみる！
EOS

nnn  = [1, 2, 3]
p nnn
puts sum = nnn.inject { |sum, i| sum + i }

puts "★each_with_objectでは書けない！結果sがFixnumであり破壊的変更を行えないので。"
# p nnn.each_with_object(0) { |i, s| s += i }

puts
puts "ワンコールならシンボルで渡せる"
puts nnn.inject :+
puts nnn.inject 50, :+    # 初期値ありでもOK



puts
puts 'reduceでも同じ'
nums = [*1..10]
p nums
puts sum = nums.reduce { |sum, i| sum + i }

puts
puts 'イテレーション中に条件を入れる時は要注意！'
r = (1..10).to_a
p r
p result = r.inject([]) { |ary, i| ary << i if i.odd?; ary }
# ★条件にマッチしない時でもaryを返すようにしないと、エラーになる（もしくは正しいinjectが行えない）
# p result = r.inject([]) { |ary, i| ary << i if i.odd? }   # -> NoMethodError

puts
puts 'each_with_objectの場合は、injectのような制限がない'
p result = r.each_with_object([]) { |i, ary| ary << i if i.odd? }

puts
puts "このような例ならfind_allを使った方がより直感的かな"
p result = r.find_all { |i| i.odd? }

puts "find_allにもシンボルで渡せる！"
p result = r.find_all(&:odd?)


puts
puts "ついでにLazyもお試し"
p (1..Float::INFINITY).lazy.map{|n| n*2}.first(5)
require 'prime'
p (1..Float::INFINITY).lazy.select(&:prime?).first(20)



puts <<-EOS.strip_heredoc

Lazyとinjectを組み合わせてみる
100以下のprimeを全部合計
EOS
# ※resultに受けずに、directにpで出力しようとするとエラーになる！
#   injectのblockがp に取られてしまうっぽい！（そして、pはblockを無視する）
#   但し、blockを do-end ではなく、より結合度の高い{} でくくった場合は、
#   blockがinjectに結合するため、正しく動作する。
#
#   http://qiita.com/riocampos/items/43e4431ddff93e01a18d
#   http://qiita.com/zom/items/97ae4e825d57a769a945
#
#   コーディングルールとしては、『単一行blockなら{}, 複数行ならdo-end』というのが多いようだが、
#   例外として、『method chainの場合には {} を使う』というのもあった。
#   ※個人的にはblockは全て{}でくくるようにした方がトラブルが減るような気がするんだが。
result = (1..Float::INFINITY)
             .lazy
             .select(&:prime?)
             .inject(0) do |total, i|
  break total if 100 < i
  total + i
end
p result


puts
puts "全然関係ないが、freezeした文字列は同じインスタンスを共有している"
5.times do
  s = 'factorial'
  f = 'freezed..'.freeze
  puts "#{s}(id:#{s.__id__})  #{f}(id:#{f.__id__})"
end



