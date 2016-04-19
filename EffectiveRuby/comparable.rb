# require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc

puts
puts "数値比較"
p 3 == 3.0    # -> true   == は「値の比較」

p 3.eql? 3.0  # -> false  ★eql?は「ハッシュキーの比較」。従って、型によっては == と結果が異なる！

p 3 == 3      # -> true

p 3.eql? 3    # -> true

p 3.equal? 3  # -> true   ★equal?はreference equal。fixnumに関してはequalとなる。

puts
puts "文字列比較"
p "a" == "a"    # -> true

p "a".eql? "a"  # -> true

p "a".equal? "a"  # -> false                ★文字列の場合は同じ値でもインスタンスが異なるので equal ではない。

p "a".freeze.equal? "a".freeze  # -> true   ★しかし、freezeすると同じインスタンスとなる。

h = { 3 => "I'm Three!"}[3.0]

p h           # -> nil

puts <<-EOS.strip_heredoc

ハッシュにおける hash, eql? の呼び出されかたを見てみる
================================================================
EOS
class Color
  attr_reader :name

  def initialize(name)
    @name = name
  end

  # ハッシュ値を返すメソッド（オーバーライド）
  def hash
    puts "#{self}.hash"
    name.hash
    # __id__
  end

  # ハッシュのキーとして同じかどうかを厳密に比較する（オーバーライド）
  # たまたまHash値が同じだったとしても、eql?の結果がfalseとなることは十分ありうる。
  def eql?(other)
    puts "#{self}.eql? (other = #{other})"
    # name.eql?(other.name)
    self.hash == other.hash
    # false
  end
end

a = Color.new("pink")

b = Color.new("pink")

puts <<-EOS.strip_heredoc

ハッシュ生成
aとbがeql? -> true となる場合は1つのkey-valueしか格納されない ※後勝ちになるようだ
EOS
p h = { a => "like", b => "love"}

puts <<-EOS.strip_heredoc

has_key(#{a}) 呼び出し
この場合は、eql? が呼び出されることなく, true と判定される。どうやら equal? -> true なら即trueとしているようだ。
EOS
p h.has_key?(a)

c = Color.new("pink")
puts <<-EOS.strip_heredoc

has_key(#{c}) 呼び出し
インスタンスが異なるので、ちゃんとeql?が呼び出される。
EOS
p h.has_key?(c)


puts
puts "大小比較  ※sortから呼び出される"
p "a" <=> "a"   # ->  0
p "a" <=> "b"   # -> -1
p "b" <=> "a"   # ->  1
p "a" <=> "A"   # ->  1

puts <<-EOS.strip_heredoc

case等値演算子
========================================================
<when値> === <case値> という形で case等値演算子===が呼び出されることを意識しておく必要がある
EOS

command = "start"
case command
when "start" then nil
when "stop", "quit" then stop
when /@cd\s+(.+)$/ then cd($1)
when Numeric then timer(command)
else raise(InvalidCommandError, command)
end

# if式に書き換えるとこのようになる。
if "start" === command then nil
elsif "stop" === command then stop
elsif "quit" === command then stop
end


p /er/ === "Tyler"    # -> true  ★正規表現でマッチングされている。
p "Tyler" === /er/    # -> false ★String#=== が呼び出されている。
