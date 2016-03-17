my_class = Class.new(Array) do
  def my_method
    p self          # -> []
    p self.class    # -> MyClass
    puts 'Hello'
  end
end
puts "定数に代入する前のクラス名: #{my_class.name}"
MyClass = my_class
puts "定数に代入した後のクラス名: #{MyClass.name}" # 代入すると、nameプロパティに名前がセットされる

puts
puts "継承関係"
p MyClass.ancestors   # -> [MyClass, Array, Enumerable, Object, Kernel, BasicObject]

puts
puts "お決まりのself"
m = MyClass.new
m.my_method


puts <<-EOS

特異メソッド
===========================================================
EOS

str = "Just a regular string"
# str = "JUST!"

# strに特異メソッド title? を定義する
def str.title?
  p self          # -> "Just a regular string"
  p self.class    # -> String
  self.upcase == self
end

puts str.title?
p str.methods             # -> [:title?, ......... ]
p str.singleton_methods   # -> [:title?]



# こちらは特異メソッド
obj = Object.new
def obj.a_singleton_method
  p self          # -> #<Object:0x371c130>
  p self.class    # -> Object
end

# こちらはクラスメソッド
def Object.another_class_method
  p self          # -> Object
  p self.class    # -> Class
end

# どちらもsingleton_method（＝特異メソッド）
p obj.singleton_methods
obj.a_singleton_method

p Object.singleton_methods
Object.another_class_method


puts <<-EOS

クラスマクロ
===========================================
EOS

class Book
  def title; puts "Just Do It!" end
  def subtitle; puts "やるかやられるか！" end

  def lend_to(user)
    puts "#{user}さんに貸し出しました。"
  end

  def lend_to_ext(user, &block)
    block.call
    lend_to user
  end

  # 古いメソッドの呼び出しは、警告した上で、新しいメソッドに流し込む
  def self.deprecate(old_method, new_method)
    define_method(old_method) do |*args, &block|
      puts "警告: #{old_method}()は非推奨です。#{new_method}()を使いましょう。"
      send(new_method, *args, &block)   # 引数とBlockはそのまま新しいメソッドに渡す
    end
  end

  deprecate :GetTitle, :title
  deprecate :LEND_TO_USER, :lend_to
  deprecate :LEND_TO_USER_SPECIAL, :lend_to_ext
end

b = Book.new
b.GetTitle

b.LEND_TO_USER("Bill")

b.LEND_TO_USER_SPECIAL("Nick") do
  puts "こいつはブラックリストユーザーです。注意喚起を。"
end