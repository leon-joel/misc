class Array
  def bogo_sort!
    shuffle! until sorted?
    self
  end

  private

  def sorted?
    each_cons(2).all? { |a, b| a <= b }
  end
end

puts "Arrayにメソッドを追加してやる！"
array = [3, 1, 2]
p array
p array.bogo_sort!



puts
puts "+ 演算子を再定義してやる！"

puts "再定義前: #{10 + 20}"

class Fixnum
  def +(args)
    self * args
  end
end

puts "再定義後: #{10 + 20}"


puts
puts "Refinementsの実験"

module ArrayEx
  refine Array do
    def baka_sort!
      shuffle! until sorted?
      self
    end

    private

    def sorted?
      each_cons(2).all? { |a, b| a <= b }
    end
  end
end

a2 = [5, 3, 4]
p a2

# 普通に呼び出してもメソッドが見つからない！ refineの効果
#a2.baka_sort!   # NoMethodError

# using以降で、モンキーパッチ（自前で拡張したメソッド）が使えるようになる！ 汚染を限定できる分ちょっと安全かな。
using ArrayEx

p a2.baka_sort!



puts
puts "Refinementsのスコープ"

require_relative 'string_ex'
# string_exファイル内で、string_exを呼び出しているので、それは成功する。
# しかし、以下の呼び出しはNoMethodErrorとなる。

# string_ex内で using StringExしているが、ここではNoMethodErrorとなる
# 「using はファイルをまたがない」とのこと。
# p 'string'.string_ex


puts
puts "クラス内にusingを記述することも出来る【Ruby2.1以降】"

module HelloWorld
  # stringにhelloを追加
  refine String do
    def hello
      puts "#{self} says : Hello, world"
    end
  end
end

class User
  # stringのhelloメソッドを使いたい
  using HelloWorld


  attr_reader :user

  def initialize(user)
    @user = user
  end

  def say
    # ここでhelloメソッドを使う
    user.hello
  end
end

# 正しく使える
User.new('User1').say # => "User1 says : Hello, world"

# しかし、こちらはダメ。Userクラス内からの呼び出しではないので。
#'User2'.hello # => NoMethodError

# もちろん、ここでusingすれば使えるようになる
using HelloWorld
'User2'.hello # OK
