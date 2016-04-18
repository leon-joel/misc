# require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc

# RubyのコアクラスライブラリにあるBindingクラスとバッティングしている
# class Binding
#   def initialize(style, options={})
#     @style = style
#     @options = options
#   end
# end
#
# p Binding.ancestors
#
# p b = Binding.new("スタイル", { opt_a: 1, opt_b: 2 })


# moduleによってNamespaceを切ればOK!
module Notebooks
  class Binding
    def initialize(style, options={})
      @style = style
      @options = options
    end
  end
end

p style = Notebooks::Binding.new("スタイル", { opt_a: 1, opt_b: 2 })


puts <<-EOS.strip_heredoc

レキシカルスコープ
===========================================
EOS

module SuperDumbCrypto
  KEY = "bazzword123"

  class Encrypt
    def initialize(key = KEY)
      @key = key
    end
  end
end

p e = SuperDumbCrypto::Encrypt.new


module SuperDumbCrypto2
  KEY = "bazzword123"
end

class SuperDumbCrypto2::Encrypt
  # この形だとKEYが見つからない。SuperDumbCrypto2::KEYとすればOK。
  # def initialize(key = KEY)
  # これならOK。レキシカルスコープはこのように働く。
  def initialize(key = SuperDumbCrypto2::KEY)
    @key = key
  end
end

p e2 = SuperDumbCrypto2::Encrypt.new  # NameError


puts <<-EOS.strip_heredoc

===================================================
EOS

module Cluster
  class Array
    def initialize(n)
      # 意図としてはコアライブラリのArrayを使っているつもりだが、
      # 実際には自前クラスのArrayを自分で循環参照してしまっている！
      # @disks = Array.new(n) { |i| "disk#{i}"}   # -> SystemStackError

      # ::を付けることで、Object::Arrayを参照している。
      # ※Object::Arrayと書いても同じ事だが、::Arrayと省略するのが普通。
      @disks = ::Array.new(n) { |i| "disk#{i}"}   # OK!
    end
  end
end

p a = Cluster::Array.new(2)