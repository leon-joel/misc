require 'active_support/core_ext/string/strip'

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

puts "strに特異メソッド title? を定義"
def str.title?
  p self          # -> "Just a regular string"
  p self.class    # -> String
  self.upcase == self
end

puts str.title?
p str.methods             # -> [:title?, ......... ] ★特異メソッドが含まれる
p str.singleton_methods   # -> [:title?]             ★特異メソッドだけが見える
p str.class               # -> String   ★普通にclassを問い合わせるとただのStringということになっているが実は↓
p str.singleton_class     # -> #<Class:#<String:0x379bae0>>  ★これが特異クラス！
p str.singleton_class.superclass    # -> String              ★親クラスがString

p str.singleton_class.instance_methods(false)   # 特異メソッドが見える


puts
puts "特異メソッドとクラスメソッドは似ている"
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

puts <<-EOS

特異クラスと継承
=======================================================

EOS
class C
  class << self
    def a_class_method
      puts "C.a_class_method called"
    end
  end
end

class D < C; end
                                                                 # 特異クラスを上に辿っていくと、すっと特異クラスであることが分かる。
p C.class                                                        # -> Class
p C.superclass                                                   # -> Object
p D.class                                                        # -> Class
p D.superclass                                                   # -> C
p D.singleton_class                                              # -> #<Class:D>
p D.singleton_class.superclass                                   # -> #<Class:C>
p D.singleton_class.superclass.superclass                        # -> #<Class:Object>
p D.singleton_class.superclass.superclass.superclass             # -> #<Class:BasicObject>
p D.singleton_class.superclass.superclass.superclass.superclass  # -> Class


puts <<-EOS

特異クラスと instance_eval
=======================================================

EOS
s1, s2 = "abc", "def"

# instance_evalはselfを変更するだけでなく、カレントクラスも特異クラスに変更している
s1.instance_eval do
  p self                   # -> "abc"
  p self.class             # -> String
  p self.singleton_class   # -> #<Class:#<String:0x37b8310>> ★特異クラス
  p self.singleton_class.superclass   # -> String
  p self.singleton_class.superclass.superclass    # -> Object

  def swoosh!; reverse; end
end

puts s1.swoosh!                 # -> cba
puts s2.respond_to?(:swoosh!)   # -> false


puts <<-EOS

モジュールの不具合【クラス拡張】
★クラスメソッドを導入
=====================================================
EOS

module MyModule2
  def self.my_class_method; puts 'hello class method'; end
  def my_instance_method; puts 'hello instance method'; end
end

class MyClass2
  # include MyModule2   # インスタンスメソッドが手に入る ★クラスメソッドではない！！！

  class << self
    p self                    # -> #<Class:MyClass2>
    p self.class              # -> Class
    p self.singleton_class    # -> #<Class:#<Class:MyClass2>>
    p self.singleton_class.superclass   # -> #<Class:#<Class:Object>>
    include MyModule2
  end
end

begin
  # include MyModule2 してもどちらもundefined methodとなる。
  # classをopenして特異クラスにincludeすれば、
  # モジュールのインスタンスメソッドがクラスメソッド（特異クラスのインスタンスメソッド）として実装される。
  # MyClass2.my_class_method
  MyClass2.my_instance_method



  puts <<-EOS.strip_heredoc

  クラスメソッドとinclude【オブジェクト拡張】
  ★特異メソッドを導入！
  =====================================================
  EOS

  obj = Object.new

  class << obj
    p self                    # -> #<Class:#<Object:0x36fa038>>
    p self.class              # -> Class
    p self.singleton_class    # -> #<Class:#<Class:#<Object:0x36fa038>>>
    p self.singleton_class.superclass # #<Class:Object>

    include MyModule2
  end

  obj.my_instance_method      # -> hello instance method

  p obj.singleton_methods     # -> [:my_instance_method]

  puts <<-EOS.strip_heredoc

  Object#extend
  レシーバの特異クラスにModuleをincludeするためのショートカット。
  クラス拡張・オブジェクト拡張を1行で書ける。
  =======================================================
  EOS

  puts "Objectに特異メソッドをinclude（Objectの特異クラスにインスタンスメソッドをinclude）"
  obj = Object.new
  obj.extend MyModule2
  obj.my_instance_method


  puts "クラスメソッドをinclude（クラスの特異クラスにインスタンスメソッドをinclude）"
  class MyClass3
    extend MyModule2
  end

  MyClass3.my_instance_method

rescue => e
  puts e
end


