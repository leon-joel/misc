#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'


class HashProxy
  def initialize
    @hash = {}
  end


  # # respond_to?などのintrospectionメソッドが正しく動作しないのが問題
  # private
  # def method_missing(name, *args, &block)
  #   if @hash.respond_to?(name)
  #     @hash.send(name, *args, &block)
  #   else
  #     super
  #   end
  # end

  # ハッシュに実装されているpublicメソッドを動的に自クラスに実装する
  Hash.public_instance_methods(false).each do |name|
    define_method(name) do |*args, &block|
      @hash.send(name, *args, &block)
    end
    # puts "#{name} defined."
  end
end


h = HashProxy.new
p h.respond_to?(:size)
puts h.size                 # -> 0

p h.public_methods(false)


puts <<-EOS.strip_heredoc

decoratorパターン
==========================================================================
EOS

class AuditDecorator
  def initialize(object)
    puts
    puts "AuditDecorator#initialize"
    @object = object
    @logger = Logger.new($stdout)

    @object.public_methods.each do |name|
      # p self    # -> AuditDecoratorインスタンス
      # define_singleton_methodメソッドは、レシーバのオブジェクトに特異メソッドを定義します
      define_singleton_method(name) do |*args, &block|
        # @logger.info("calling #{name} on #{@object.inspect}")

        # メソッド内では、@objectが使用できる
        @object.send(name, *args, &block)
      end
    end

    p self.class.ancestors            # -> [String, Comparable, Object, Kernel, BasicObject]
    p self.singleton_class.ancestors  # -> [#<Class:#<String:0x2aac308>>, String, Comparable, Object, Kernel, BasicObject]
  end

  # private
  # def method_missing(name, *args, &block)
  #   @logger.info("calling #{name} on #{@object.inspect}")
  #   @object.send(name, *args, &block)
  # end

  # # method_missingを使わざるを得ない場合は respond_to_missing? も併用することを検討
  # def respond_to_missing?(name, include_private)
  #   @hash.respond_to?(name, include_private) || super
  # end
end

puts
puts "main"
fake = AuditDecorator.new("Am I a string?")
puts fake.downcase

# p fake.class
# p fake.class.ancestors      # -> [String, Comparable, Object, Kernel, BasicObject]
p fake.class.public_instance_methods(false)