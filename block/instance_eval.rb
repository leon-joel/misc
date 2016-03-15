p self        # -> main
main_var = "mainの変数"

class MyClass

  p self      # -> MyClass

  def initialize
    p self    # -> #<MyClass:0x37a5f20>
    @v = 1
  end


end

obj = MyClass.new


puts <<-'EOS'

■instance_evalでレシーバーのprivateメソッドやインスタンス変数にアクセスする！
  しかも、外側（ここで言うとmain）のローカル変数にもアクセス出来る！

  ＜RubyDoc＞
    instance_evalメソッドは、渡されたブロックをレシーバのインスタンスの元で実行します。
    ブロックの戻り値がメソッドの戻り値になります。
    ブロック内では、インスタンスメソッド内でコードを実行するときと同じことができます。
    ブロック内でのselfはレシーバのオブジェクトを指します。
    なお、ブロックの外側のローカル変数はブロック内でも使えます。

EOS


obj.instance_eval do
  # instance_evalに渡すブロックのことを【コンテキスト探査機】と呼ぶ

  p self    # -> #<MyClass:0x3763920 @v=1>
  puts @v      # -> 1

  puts main_var
end

obj.instance_eval do
  @v = "#{main_var} をインスタンス変数に取り込み"
  puts @v

  main_var = "instance_eval内でmain_varを変更"
end

puts main_var


puts
puts <<-'EOS'
instance_evalでも外側のインスタンス変数にはアクセス出来ない！
EOS

class C
  def initialize
    @x = 1
  end
end

class D
  def twisted_method
    @y = 2
    p self    # -> #<D:0x376cef0 @y=2>
              # クラスDには@yインスタンス変数がセットされている
              # しかし、クラスCのinstance_evalブロックからはアクセス出来ない！
              # インスタンス変数はselfによって決まるため、とのこと。
              # つまり、インスタンス変数は混ざらない！といっていいのかな。
    C.new.instance_eval do
      p self  # -> #<C:0x376ce60 @x=1>
      "@x: #{@x}, @y: #{@y}"    # ★yが空(nil)になっている！
    end
  end
end

puts D.new.twisted_method   # -> @x: 1, @y:


puts
puts 'instance_execなら引数を使ってインスタンス変数でも何でも渡せる'

class D2
  def twisted_method
    @y = 3
    p self      # -> #<D2:0x3770610 @y=3>

    C.new.instance_exec(@y) do |y|
      p self    # -> #<C:0x3770580 @x=1>
      "@x: #{@x}, @y: #{y}"
    end
  end
end

puts D2.new.twisted_method


puts
puts 'クリーンルーム'
puts 'ブロックを評価するためだけの環境。通常はBasicObjectのインスタンスが最適。'
class CleanRoom
  def current_temperature

  end
end

clean_room = CleanRoom.new
clean_room.instance_eval do
  # DO SOMETHING
end