my_var = '成功'

class MyClass     # 【スコープゲート】
  # my_var はここからは見えない
  # puts my_var

  def my_method   # 【スコープゲート】
    # もちろんここでも見えない
    # puts my_var
  end
end


mc = MyClass.new
mc.my_method




puts
puts 'スコープゲートを外す！【スコープのフラット化】【入れ子構造のレキシカルスコープ】'

puts '1. クロージャを使って、classを動的に生成する'
MyClass2 = Class.new do
  puts "クラス定義内からトップレベルのmy_varを参照できる: #{my_var}"


  puts '2. クロージャを使って、methodも動的に生成する'
  define_method :my_method do
    puts "メソッド定義内からもトップレベルのmy_varを参照する: #{my_var}"
  end
end

mc2 = MyClass2.new
mc2.my_method


puts
puts 'スコープの共有'

main_var = 'main var'
p self        # -> main

def define_my_methods  # 【スコープゲート】
  # 内部はフラットスコープとして、変数を共有している。

  shared = 0      # 共有したい変数

  Kernel.send :define_method, :counter do
    p self    # -> main
    puts shared
    # puts main_var  # これは見えない
  end

  Kernel.send :define_method, :inc do |x|
    shared += x
  end
end

define_my_methods


counter   # -> 0
inc(4)    # ここでインクリメント
counter   # -> 4