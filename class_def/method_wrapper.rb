require 'active_support/core_ext/string/strip'

puts <<-EOS.strip_heredoc
Module#alias_method
==============================================
EOS

class MyClass
  def my_instance_method; puts 'my_instance_method()'; end

  # m という別名を付ける
  alias_method :m, :my_instance_method
end

obj = MyClass.new
obj.my_instance_method  # 古い名前
obj.m                   # 新しい名前

puts <<-EOS.strip_heredoc

エイリアスしてオリジナルを再定義【アラウンドエイリアス】
====================================================
EOS

class String
  puts "1. オリジナルのlengthにreal_lengthという別名を付ける＝オリジナルのlengthを退避している"
  alias_method :real_length, :length

  puts "2. lengthを再定義"
  def length
    5 < real_length ? 'long' : 'short'
  end

  puts "注意！ 1. と 2. の順番を逆にすると、length/real_length呼び出しが無限ループになる！"
end

puts "War and Peace".length       # -> long
puts "War and Peace".real_length  # -> 13



