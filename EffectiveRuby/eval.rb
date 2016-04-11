#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'

def glass_case_of_emotion
  x = "I'm in a " + __method__.to_s.tr('_', ' ')
  binding   # -> ローカルスコープを返す
end

x = "I'm in a scope"

# スコープが指定されていない場合は、evalが置かれているスコープで評価される
puts eval("x")                          # -> I'm in a scope


# スコープが指定されている場合は、そのスコープで評価される
puts eval("x", glass_case_of_emotion)   # -> I'm in a glass case of emotion

puts <<-EOS.strip_heredoc

=======================================================
EOS

class Widget
  def initialize(name)
    @name = name
  end

  def aaa
    "help"
  end
end


w = Widget.new("Muffler Bearing")

# w オブジェクトをScopeとして評価される
puts w.instance_eval { @name }

# w オブジェクトに特異メソッドが定義される
w.instance_eval do
  def in_stock?; false; end
end

p w.singleton_class.ancestors     # -> [#<Class:#<Widget:0x29c4ae0>>, Widget, Object, Kernel, BasicObject]
p w.singleton_methods(false)      # -> [:in_stock?]
p w.public_methods(false)         # -> [:in_stock?, :aaa]

puts "特異メソッドを入れていないインスタンスはどうなっている？"
aaaa = Widget.new("AAAAA")
p aaaa.singleton_class.ancestors  # -> [#<Class:#<Widget:0x29cfbb0>>, Widget, Object, Kernel, BasicObject]
p aaaa.singleton_methods(false)   # -> []
p aaaa.public_methods(false)      # -> [:aaa]

puts <<-EOS.strip_heredoc

クラスコンテキストでの特異メソッド定義、つまりクラスメソッドの定義
===============================================================
EOS

Widget.instance_eval do
  def table_name; "widgets"; end
end

puts Widget.table_name              # -> widgets
p Widget.singleton_methods(false)   # -> [:table_name]

puts <<-EOS.strip_heredoc

普通のインスタンスメソッドを定義する
=============================================================
EOS

Widget.class_eval do
  attr_accessor :name

  def sold?; false; end
end

w = Widget.new("Blinker Fluid")

p w.public_methods(false)       # -> [:aaa, :name, :name=, :sold?]

puts <<-EOS.strip_heredoc

インスタンス変数に直接アクセス
=============================================================
EOS

class Widget
  attr_accessor :name, :quantity

  def initialize(&block)
    instance_eval(&block) if block
  end
end

w = Widget.new do |widget|
  # このブロックはinstance_evalに渡されるため、インスタンス内部のスコープで表される
  widget.name = "Elbow Grease"  # もちろんアクセッサー経由でもアクセス出来るが、
  @quantity = 2                 # インスタンス変数に直接アクセスすることも可能！
end
puts [w.name, w.quantity]

puts <<-EOS.strip_heredoc

evalに文字列ではなくBlockを渡すことで殆どの場合は事足りる
==============================================================
EOS

class Counter
  DEFAULT = 0
  attr_reader :counter

  def initialize(start=DEFAULT)
    @counter = start
  end

  def inc
    @counter += 1
  end
end

module Reset
  def self.reset_var(object, name)
    object.instance_eval("@#{name} = DEFAULT")
  end
end

p c = Counter.new(10)
p Reset.reset_var(c, "counter")

# 変な文字列を与えるとSyntaxErrorが発生する syntax error, unexpected '=', expecting end-of-input (SyntaxError)
# Reset.reset_var(c, "x;")

module Reset2
  def self.reset_var(object, name)
    # instance_evalを使わず記述。
    object.instance_exec("@#{name}".to_sym) do |var|
      const = self.class.const_get(:DEFAULT)
      instance_variable_set(var, const)
    end
  end
end

# 存在しない変数名を与えるとNameErrorが発生する。 `@c;' is not allowed as an instance variable name (NameError)
# エラー内容がより具体的でこちらのほうがベター。
Reset2.reset_var(c, "c;")
