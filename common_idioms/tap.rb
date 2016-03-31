require 'active_support/core_ext/string/strip'

puts '多くの処理をつなげて書けるが…'
p ['a', 'b', 'c'].push('d').shift.upcase.next

puts
puts '途中にデバッグ出力を挟み込むのは結構面倒'
p x = ['a', 'b', 'c']
p a = x.push('d')
p s = a.shift
p u = s.upcase
p n = u.next

puts
puts "tapでデバッグ出力を挟み込む"
['a', 'b', 'c']
    .push('d').tap{|x| p x}
    .shift.tap{|x| p x}
    .upcase.tap{|x| p x}
    .next.tap{|x| p x}
