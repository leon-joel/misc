require 'rspec'


module IncludeMod
  def run
    'IncludeMod#run'
  end
end
module PrependMod
  def run
    'PrependMod#run'
  end

end

class ParentClass
  def run
    'ParentClass#run'
  end
end

class ChildClass < ParentClass; end


describe "include と prepend の実験" do

  it do
    puts "\n### 最初は何も include/prepend していない状態"
    p ChildClass.ancestors
    # => [ChildClass, ParentClass, Object, Kernel, BasicObject]

    c = ChildClass.new
    p c.singleton_class.ancestors
    # => [#<Class:#<ChildClass:0x3621af8>>, ChildClass, ParentClass, Object, Kernel, BasicObject]
    #     ↑先頭のクラスが特異クラス

    puts c.run    # => ParentClass#run
    c2 = ChildClass.new

    puts "\n### では IncludeMod を include してみる"
    c.class.include IncludeMod

    p ChildClass.ancestors
    # ChildClass と ParentClass の間に IncludeMod が挟まった
    # => [ChildClass, IncludeMod, ParentClass, Object, Kernel, BasicObject]

    # IncludeMode の run が呼び出される
    puts c.run    # => IncludeMod#run
    puts c2.run   # => 同上 ※当然同一クラスの別インスタンスでも結果は同じ

    puts "\n### 今度は PrependMod を prepend してみる"
    c.class.prepend PrependMod
    p ChildClass.ancestors
    # ChildClassの手前（かつ特異クラスよりは奥）に PrependMod が追加された
    # => [PrependMod, ChildClass, IncludeMod, ParentClass, Object, Kernel, BasicObject]
    p c.singleton_class.ancestors
    # => [#<Class:#<ChildClass:0x3621af8>>, PrependMod, ChildClass, IncludeMod, ParentClass, Object, Kernel, BasicObject]
    #     ↑先頭のクラスが特異クラス
    p c.singleton_class.instance_methods(false) # => []

    # よって PrependMod の run が呼び出される
    puts c.run    # => PrependMod#run
    puts c2.run   # => 同上

    puts "\n### 特異メソッドを注入してみる"
    class << c  # 特異クラスを引き出して…
      def run   # 特異メソッドを定義する
        'MyClass#run'
      end
    end
    ### こういう定義の仕方もある。メソッドを1つ定義するだけならこちらの方が行数が少なくて良いが、特異クラスを引き出していることが見えにくい。
    # def c.run
    #   'MyClass#run'
    # end

    # クラス階層的には変化なし
    p ChildClass.ancestors
    # => [PrependMod, ChildClass, IncludeMod, ParentClass, Object, Kernel, BasicObject]
    p c.singleton_class.ancestors
    # => [#<Class:#<ChildClass:0x3621af8>>, PrependMod, ChildClass, IncludeMod, ParentClass, Object, Kernel, BasicObject]
    #     ↑先頭に特異クラスがあるのが見える
    p c
    # => #<ChildClass:0x3621af8>
    p c.singleton_class.instance_methods(false) # => [:run] ※追加された

    # 当然特異クラスのメソッドが呼び出される
    puts c.run    # => MyClass#run

  end

end