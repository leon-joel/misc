module Foo1; end

module Foo2; end

class Bar; end


class Foobar < Bar
  include Foo1
  include Foo2

  def self.foobar_self

  end

  def foobar

  end
end


# Foobarクラスのインスタンスメソッド
p Foobar.instance_methods(false)  # -> foobar

# Foobarクラスの特異クラスのインスタンスメソッド
p Foobar.singleton_class.instance_methods(false)  # -> foobar_self


# 親クラス
p Foobar.superclass   # -> Bar

# 継承階層を取得 ★MixinしているFooモジュールも継承階層に出てきた！
p Foobar.ancestors    # -> [Foobar, Foo2, Foo1, Bar, Object, Kernel, BasicObject]


puts
puts "### クラス変数・クラスインスタンス変数・インスタンス変数 の違い ###"

# http://necojackarc.hatenablog.com/entry/2015/08/03/035752
# http://d.hatena.ne.jp/kabakiyo/20080525/1211728832

class Babar
  # ■クラス変数 ※Babarおよび派生クラスのインスタンス全てで共有される変数
  #   class static変数といったところ。（まぁ分かりやすい）
  @@bar = "bar"

  def self.bar=(bar)
    @@bar = bar
  end

  def self.bar
    @@bar
  end


  # クラス定義に直に@xxxを書くとクラスインスタンス変数となる！
  # ★これが分かりにくい！！！！分かりにくすぎてまともに使いこなせる気がしない… とにかく要注意！
  # ★派生クラスからはアクセスできない
  @poo = "poo"

  # クラスメソッドからクラスインスタンス変数でのアクセス
  # ★Babarクラスでは意図した通りに動くが、派生クラスからは@pooにアクセス出来ない！
  # ★派生クラスで poo = を呼び出すと、当該クラスに クラスインスタンス変数が生成されるようだ。
  def self.poo=(poo)
    @poo = poo
  end

  def self.poo
    @poo
  end

  # インスタンス変数 ※コンストラクタなどのインスタンスメソッド内で@xxxを書くとインスタンス変数となる
  # ※ごく普通のメンバー変数といったところ。
  def initialize
    @poo_i = "bar_i"
  end

  # インスタンスメソッドでインスタンス変数にアクセスする ※こちらもごく普通の振る舞い
  def poo_i=(poo)
    @poo_i = poo
  end

  def poo_i
    @poo_i
  end

end

class FooBabar < Babar

end

class HooBabar < Babar

end


puts 'クラス変数へのアクセス'
p Babar.bar       # -> bar
p FooBabar.bar    # -> bar
p HooBabar.bar    # -> bar

puts
FooBabar.bar = "foo"  # この変更がBabarおよび派生クラス全てに影響する
p Babar.bar       # -> foo
p FooBabar.bar    # -> foo
p HooBabar.bar    # -> foo  ★こちらも変わっている！つまり、クラス変数（@@xxx）は派生クラスからも共有される！


puts
puts 'クラスメソッド⇒クラスインスタンス変数へのアクセス'
p FooBabar.class_variables      # -> [@@bar]
p Babar.poo       # -> poo
Babar.poo = "BP"
p Babar.poo       # -> BP  ※これはOK


puts
puts "派生クラスから基底クラスのクラスインスタンス変数にアクセスしてみる"
p FooBabar.instance_variables   # -> []   ※もちろん、クラスインスタンス変数は何も定義されていない

p FooBabar.poo    # -> nil ★派生クラスから基底クラスのクラスインスタンス変数にはアクセス出来ない！
p HooBabar.poo    # -> nil ★同上

p FooBabar.instance_variables   # -> []   ※まだ、クラスインスタンス変数は何も定義されていない

puts
puts "クラスインスタンス変数が生成される"
FooBabar.poo = "FBP"
HooBabar.poo = "HBP"
p FooBabar.poo    # -> FBP
p HooBabar.poo    # -> HBP

p FooBabar.instance_variables # -> [:@poo]


puts
puts 'インスタンスメソッド⇒インスタンス変数へのアクセス'
f = FooBabar.new
h = HooBabar.new
p f.poo_i         # -> bar_i ※基底クラスのinitializeで定義されたデフォルト値が返される。（ごく自然な振る舞い）
p h.poo_i         # -> bar_i ※同上

f.poo_i = "fpi"   # 明示的にセットする
h.poo_i = "hpi"   # 明示的にセットする
p f.poo_i         # -> fpi   ※もちろん、セットした値が返される。（こちらもごく自然な振る舞い）
p h.poo_i         # -> hpi   ※同上

p f.instance_variables  # [:@poo_i]


puts
puts "クラスインスタンス変数のアクセッサだけを基底クラスで定義しておき"
puts "クラスインスタンス変数自体は派生クラス側で定義する。"

module InheritSample
  class Bar
    def self.bar=(bar)
      @bar = bar
    end

    def self.bar
      @bar
    end
  end

  class Foobar < Bar
    @bar = "foobar"
  end

  class Hoobar < Bar
    @bar = "hoobar"
  end
end


p InheritSample::Bar.instance_variables     # -> []       ★当然クラスインスタンス変数は定義されていない
p InheritSample::Foobar.instance_variables  # -> [:@bar]  ★派生クラスには定義されている。これも当然

p InheritSample::Foobar.bar   # -> foobar  ★つまり、アクセッサ（self.bar）は基底クラスで定義しておいて、
                              #              クラスインスタンス変数自体は派生クラスで定義する、という仕組みになっている。
