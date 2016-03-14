puts <<-'EOS'
スコープの移り変わりについて

スコープゲートの概念を理解すること。
rubyではclass/module/def(method)がスコープゲートとなっている。
EOS

v1 = 1

class MyClass           # 【スコープゲート】classの入り口
  v2 = 2
  p local_variables     # [:v2]

  def my_method         # 【スコープゲート】methodの入り口
    v3 = 3
    p local_variables   # [:v3]
  end                   # 【スコープゲート】methodの出口

  p local_variables     # [:v2]
end                     # 【スコープゲート】classの出口


obj = MyClass.new
obj.my_method
obj.my_method

p local_variables       # [:v1, :obj]


puts
puts 'グローバル変数'
def a_scope
  $var = "global var"   # グローバル変数
end

def another_scope
  $var
end

a_scope

puts another_scope         # システムのどこからでも参照可能

puts
puts 'トップレベル(main)のインスタンス変数'

@var = 'トップレベル(main)の変数@var'

def my_top_method
  p self        # main
  puts @var     # selfがmainなので、当然ここでも参照できる
end

my_top_method


puts
puts 'selfが変われば（＝スコープが変われば）トップレベルのインスタンス変数は見えなくなる'

class MyClass2

  def my_method
    p self
    @var = 'トップレベルの変数@varとは違うよ！'
    puts @var
  end
end


obj2 = MyClass2.new
obj2.my_method

my_top_method

obj2.my_method
