puts <<-EOS
Rubyのクラス定義は実際にコードを【実行】している！
EOS

class MyClass
  puts
  puts "クラス定義内"
  p self          # -> MyClass
  p self.class    # -> Class

  class << self
    puts
    puts "クラスをopenした"
    p self        # -> #<Class:MyClass>  ClassクラスのインスタンスMyClass
    p self.class  # -> Class

    def c_method1
      puts
      puts "クラスをopenしたクラスメソッド内"
      p self        # -> MyClass            【カレントオブジェクト】
      p self.class  # -> Class              【カレントクラス】
    end
  end

  def self.c_method2
    puts
    puts "クラスメソッド内 ※結果はもちろんc_method1と同じ"
    p self        # -> MyClass              【カレントオブジェクト】
    p self.class  # -> Class                【カレントクラス】
  end

  def i_method
    puts
    puts "インスタンスメソッド内"
    p self        # -> #<MyClass:0x37324e0> 【カレントオブジェクト】
    p self.class  # -> MyClass              【カレントクラス】
  end
end

MyClass.c_method1
MyClass.c_method2

MyClass.new.i_method

puts
puts "class命令？には戻り値もある"
result = class MyClass2
           p self           # -> MyClass2 【カレントオブジェクト】
           p self.class     # -> Class    【カレントクラス】
           2
end
p result  # -> 2

puts
puts "トップレベル"

p self        # -> main
p self.class  # -> Object 【カレントクラス】


puts <<-EOS

==========================================
EOS

class C
  # メソッド内でメソッドを定義している！！！なにこれ！！
  def m1
    def m2; end
  end
end

class D < C; end

p C.instance_methods(false)   # -> [:m1]      ★m1を実行する前はm1しかない

obj = D.new
obj.m1

p C.instance_methods(false)   # -> [:m1, :m2] ★m1を実行するとm2も定義された！


puts <<-EOS

==============================================
クラス名が分からない時にclassをopenするにはModule#class_eval
EOS


def add_method_to(a_class)
  a_class.class_eval do   # a_classにStringを与えた場合
    p self                # -> String  確かにStringクラスをOpenしている
    p self.class          # -> Class
    puts

    def m
      p self
      p self.class
      puts "Hello!"
    end
  end
end

add_method_to String
"abc".m


puts <<-EOS

=====================================================
クラスインスタンス変数
同じ名前でもクラスインスタンス変数とインスタンス変数は明確に区別されている。

EOS

class MC3
  p self
  @my_var = 1
  def self.read; p self; puts "クラスインスタンス変数: #{@my_var}"; end

  def write; @my_var = 2; end
  def read; p self; puts "インスタンス変数: #{@my_var}" ; end
end

MC3.read
puts

obj = MC3.new
obj.read
obj.write
obj.read

puts <<-EOS

======================================================
クラス変数
EOS
@@v = 1
p @@v       # -> 1

p self.class
p self.class.class_variables

class MyClass4
  p self.class
  p self.class.class_variables

  p @@v     # -> 1  ★トップレベルで定義したクラス変数（＝Objectクラスの持ち物）が見えている！


  @@v = 2   #
  p @@v     # -> 2

end

p @@v       # -> 2