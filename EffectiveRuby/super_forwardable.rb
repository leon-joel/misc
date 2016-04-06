#require 'pp'
require 'active_support/core_ext/string/strip'


puts <<-EOS.strip_heredoc
EffectiveRuby 項目21 & 28
委譲、モジュール、フック

EOS


module SuperForwardable

  # モジュールフック（extendされた時に呼び出される）
  def self.extended(klass)
    require 'forwardable'
    # Forward
    klass.extend(Forwardable)
  end

  # superを呼び出す移譲ターゲットを作るクラスマクロ ※SuperForwardableをextendされることを想定している
  def def_delegators_with_super(target, *methods)
    methods.each do |method|
      target_method = "#{method}_without_super".to_sym

      # targetのmethodを呼び出すalias(target_method)を定義。
      # 言い方を変えると、target_methodの呼び出し ＝ target#methodの呼び出し となる。
      def_delegator(target, method, target_method)

      # 委譲＋super なメソッドを定義する
      define_method(method) do |*args, &block|
        # 委譲（上で作ったaliasを呼び出す）
        send(target_method, *args, &block)
        # superを呼び出す
        super(*args, &block)
      end
    end
  end
end



class RaisingHash
  # extendすることで、def_delegators_with_superをクラスメソッド（クラスマクロ）として使用できるようにしている。
  # SuperForwardableのextendedフック内でForwardableもextendしてくれているので、
  # def_delegatorsもクラスメソッドとして使えるようになる。
  extend SuperForwardable

  # メソッド呼び出しを@hashに横流しするだけ
  def_delegators(:@hash, :[], :[]=)

  # @hashのメソッドを呼び出した後、superも呼び出す
  # ※superを呼び出さないと、自分自身（RaisingHash）がfreezeされないという事態になる
  def_delegators_with_super(:@hash, :freeze, :taint, :untaint)

  def initialize
    puts "initialize"
    @hash = Hash.new do |hash, key|
      raise(KeyError, "invalid key '#{key}'!")
    end
    puts "  self(RaisingHash): #{self.__id__}"
    puts "              @hash: #{@hash.__id__}"
  end

  # dup, clone から呼び出される
  # ※dup, cloneもshallow copyだが、RaisingHashはHashを偽装？しているので、
  # @hashは自前でdupしてあげないといけない。
  # （これをやらないと、RaisingHashは別インスタンスなのに中身のhashは同じものを共有することになる。
  # @param [RaisingHash] コピー元のオブジェクト
  def initialize_copy(original_obj)
    puts "initialize_copy"
    # @hashにはコピー元の@hashが入っているので、それをdupして@hashに入れるだけでOK。※そもそもoriginal_objの@hashにアクセス出来ないので…
    puts "  self(RaisingHash): #{self.__id__}"
    puts "  original_obj     : #{original_obj.__id__}"
    puts "       new_obj.hash: #{@hash.__id__}"
    p @hash = @hash.dup
    puts "   dup_new_obj.hash: #{@hash.__id__}"
  end

  # RaisingHashクラスの新しいインスタンスを返さないといけないので、単純に委譲できない。
  # 仕方ないから自前で実装する
  def invert
    other = self.class.new
    # Hash#invertで生成されるハッシュはdefault_procがデフォルトに戻ってしまう。
    # なので、replaceによりdefault_procも差し替えている。
    other.replace!(@hash.invert)
    other
  end

  protected
  # 置き換え： @hash ← hash
  #   ★default_procはオリジナルの@hashから新しい@hashに付け替える
  def replace!(hash)
    puts "replace!"
    hash.default_proc = @hash.default_proc
    @hash = hash
  end


end

p RaisingHash.instance_methods(false)
puts

rh = RaisingHash.new
rh["1"] = "test"

p rh
p v = rh["1"]

# v = rh["2"]   # -> KeyError
# p v

puts "dupした"
rh_dup = rh.dup
p rh_dup

puts "invertした"
p rh.invert

# p rh["test2"]   # -> KeyError


puts "delegateを試す"
puts "http://magazine.rubyist.net/?0012-BundledLibraries"

puts <<-EOS.strip_heredoc

SimpleDelegator
=======================================================
EOS


require 'delegate'
foo = SimpleDelegator.new([])
foo.push(1)
foo.push(2)
puts "foo.size: #{foo.size}"  # -> 2

p foo                         # -> [1, 2]
p foo.class
p foo.class.ancestors         # -> [SimpleDelegator, Delegator, #<Module:0x29c9da8>, BasicObject]
p foo.class.instance_methods

puts "委譲先オブジェクト"
p foo.__getobj__              # -> [1, 2]
p foo.__getobj__.class.ancestors        # -> [Array, Enumerable, Object, Kernel, BasicObject]


puts
puts "RubyDocの例"

foo = Object.new
def foo.test
  p 25
end

foo2 = SimpleDelegator.new(foo)
foo2.test
p foo.class.ancestors         # -> [Object, PP::ObjectMixin, Kernel, BasicObject]

                              # ppをrequireしないようにすると、
                              # -> [Object, Kernel, BasicObject]

p foo2.__getobj__             # -> #<Object:0x2a67500>

puts <<-EOS.strip_heredoc

DelegateClass()
=======================================================
EOS
class ExtArray < DelegateClass(Array)
  def initialize
    super([])
  end
end

p ExtArray.ancestors          # -> [ExtArray, #<Class:0x2a314e8>, Delegator, #<Module:0x299ded0>, BasicObject]
a = ExtArray.new
a.push 25
p a

p a.methods
p a.instance_variables
p a.__getobj__.class

puts <<-EOS.strip_heredoc

inheritedフックを使って、継承禁止クラスを作成する
EOS

module PreventInheritance
  class InheritanceError < StandardError; end

  def inherited(child)
    raise(InheritanceError, "#{child} cannot inherit from #{self}")
  end
end

p Array.singleton_methods         # -> [:[], :try_convert]

Array.extend(PreventInheritance)  # extendすることで、モジュールに定義したフックメソッド（インスタンスメソッド）を
                                  # クラスメソッドとして取り込ませる

p Array.singleton_methods         # -> [:[], :try_convert, :inherited]

begin
  class BetterArray < Array; end    # -> BetterArray cannot inherit from Array (PreventInheritance::InheritanceError)
rescue => e
  puts e
end

puts <<-EOS

その他のフックメソッド
==========================================================
EOS

class InstanceMethodWatcher
  def self.method_added(m);     puts "added #{self}##{m}"; end
  def self.method_removed(m);   puts "removed #{self}##{m}"; end
  def self.method_undefined(m); puts "undefined #{self}##{m}"; end

  def hello; end

  remove_method(:hello)

  def hello; end

  undef_method(:hello)


  def self.singleton_method_added(m); puts "added singleton method #{self}::#{m}"; end
  def self.singleton_method_removed(m); puts "removed singleton method #{self}::#{m}"; end
  def self.singleton_method_undefined(m); puts "undefined singleton method #{self}::#{m}"; end

  def self.hello; end

  # self.remove_method(:hello)  # これはNG -> private method `remove_method' called for InstanceMethodWatcher:Class (NoMethodError)
  class << self                 # これはOK。remove_methodは【特異クラスのprivateメソッド】なので、classをOPENしないと呼び出せない。
    p self.ancestors            # -> [#<Class:InstanceMethodWatcher>, #<Class:Object>, #<Class:BasicObject>, Class, Module, Object, Kernel, BasicObject]
    remove_method(:hello)
  end

  p self.ancestors              # -> [InstanceMethodWatcher, Object, Kernel, BasicObject]

  def self.hello; end

  class << self; undef_method(:hello); end
end


puts <<-EOS

inheritedフックを使った「派生クラスを登録する仕組み」
※Factoryパターンで利用できる。
============================================================
EOS

class DownloaderBase
  def self.inherited(subclass)
    super                         # クラスフックの中にはsuper呼び出しを入れよう（項目29，p.114）
    puts "derived #{subclass} from #{self}"
    handlers << subclass
  end

  def self.handlers
    @handlers ||= []
  end

  private_class_method(:handlers)
end

class SSHDownloader < DownloaderBase; end
class HTTPDownloader < DownloaderBase; end
class FtpDownloader < DownloaderBase; end
class TFtpDownloader < FtpDownloader; end    # 派生クラスの派生クラス ※基底クラスのhandlerには登録されない

p TFtpDownloader.ancestors


class TFtpDownloader
  # p handlers
end

# p DownloaderBase.class_variables
# p DownloaderBase.private_instance_methods
# p DownloaderBase.private_methods

class DownloaderBase
  puts "#{self} : #{handlers}"
end

class FtpDownloader
  puts "#{self} : #{handlers}"
end