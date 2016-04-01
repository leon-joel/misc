require 'pp'
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






★★★★★★★★★★ delegateも試してみたい ★★★★★★★★★★★★
http://magazine.rubyist.net/?0012-BundledLibraries