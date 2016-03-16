puts <<-EOS
Rubyのクラス定義は実際にコードを【実行】している！
EOS

class MyClass
  p self          # -> MyClass
  p self.class    # -> Class
  puts "Hello"
  puts

  class << self
    p self        # -> #<Class:MyClass>  ClassクラスのインスタンスMyClass
    p self.class  # -> Class

  end

  puts
  def test
    p self        # -> #<MyClass:0x37324e0>
    p self.class  # -> MyClass
  end
end

MyClass.new.test

puts
puts "戻り値もある"
result = class MyClass2
           p self           # -> MyClass2 【カレントオブジェクト】
           p self.class     # -> Class    【カレントクラス】
           2
end

p self        # -> main
p self.class  # -> Object 【カレントクラス】
p result      # -> MyClass2