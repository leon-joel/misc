
require 'monetize'
I18n.enforce_available_locales = false


require 'active_support/core_ext/string/strip'



puts '=== オープンクラス'

# MonetizeのクラスメソッドでMoneyインスタンスを生成
bargain_price = Monetize.from_numeric(99, 'USD')
p bargain_price.format


# Numericクラスのto_moneyインスタンスメソッドを使用 ★monetizeがメソッドを追加している
standard_price = 100.to_money('USD')
p standard_price.format


puts
puts '=== 定数'
puts '外側の定数と内側の定数は同じではない！'
puts '「モジュール（クラス）がディレクトリで、定数がファイル」といえる。'

MyConstant = 'ルートの定数'

module MyModule
  MyConstant = '外側の定数'

  class MyClass
    MyConstant = '内側の定数'

    puts
    puts 'クラス内から参照'
    puts ::MyConstant
    puts MyModule::MyConstant
    puts MyConstant

    module M2
      puts
      puts 'モジュール（クラス）の階層'
      p Module.nesting
    end

  end

  puts
  puts 'モジュール内から参照'
  puts ::MyConstant
  puts MyConstant
  puts MyClass::MyConstant
end

puts
puts 'トップレベルから参照'
puts MyConstant
puts MyModule::MyConstant
puts MyModule::MyClass::MyConstant


puts
puts '定数一覧'
p self.class
p self.class.constants
p Module.constants            # クラスメソッドの constants -> トップレベルの定数を返す
p MyModule.constants(false)   # インスタンスメソッドの constants -> 現在のスコープにある定数を返す
p MyModule::MyClass.constants(false)  # 同上

puts
puts 'Classクラスのインスタンスメソッド'
p Class.instance_methods(false)   # newなどが含まれる
# p Class.superclass.instance_methods
# p Class.methods


puts
puts <<-'EOS'
継承ツリーをさかのぼる
Kernelモジュールが継承ツリーに入り込んでいる点に着目！
これはObjectが include Kernel しているため、継承ツリー上のObjectの前に挟まっている。
余談: includeではなくprependしていたら、Objectの後ろに挟まることになる。
EOS

p MyModule::MyClass.ancestors       # -> [MyModule::MyClass, Object, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]

puts
puts 'その他'
p MyModule.class                    # -> Module
p MyModule.class.superclass         # -> Object
p MyModule.class.superclass.superclass  # -> BasicObject
p MyModule.class.superclass.class   # -> Class

myc = MyModule::MyClass.new
p myc.class                         # -> MyModule::MyClass
p myc.class.superclass              # -> Object


puts
puts 'インスタンス変数のセット'
p myc.instance_variable_set(:@x, 10)
p myc.inspect

puts
puts <<-'EOS'
rubyにおけるprivateの意味『privateルール』について
  ルール1）自分以外のオブジェクトのメソッドを呼び出すにはレシーバーを明示的に指定する必要がある
  ルール2）privateメソッドはレシーバーを明示的に指定して呼び出すことは出来ない
これらのルールにより、privateメソッドは当該クラスおよびその派生クラスからしか呼び出すことが出来ない、
という結論になる。
EOS

class MyC1
  def public_method1
    # ルール2）に違反しているのでこれはエラーになる！
    # self.private_method1

    # これはOK！
    private_method1
  end

  private

  def private_method1
    puts "called."
  end
end

MyC1.new.public_method1

# これもルール2）に違反しているのでエラーになる！
# MyC1.new.private_method1

puts
puts 'Refinementsの実験'

module StringExtension
  refine String do
    def reverse
      'esrever'
    end
  end
end

module StringStuff
  using StringExtension
  p 'my_string'.reverse   # refine内で定義された自前実装が呼び出される
end

p 'my_string'.reverse     # オリジナルのreverseが呼び出される

puts
puts 'Refinementsの驚くべき習性'

class MyClass
  def my_method
    'original my method'
  end

  def another_method
    my_method
  end
end

module MyClassRefinements
  refine MyClass do
    def my_method
      'refine my method'
    end
  end
end

using MyClassRefinements
p MyClass.new.my_method       # -> refine...

p MyClass.new.another_method  # -> original...  ★パッチが効いていない！！！！



# refineではなく、globalにパッチを当ててみる
class MyClass
  def my_method
    'monkey my method'
  end
end

p MyClass.new.my_method       # -> refine... が依然有効！
p MyClass.new.another_method  # -> monkey... ★refineではなくglobalにパッチをあてた場合は、ちゃんと効く