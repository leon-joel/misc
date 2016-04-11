#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'


puts <<-EOS.strip_heredoc
モジュールでの単純なパッチ
==========================================================
EOS

module OnlySpace
  ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

  def self.only_space?(str)
    if str.ascii_only?
      !str.bytes.any? { |b| b != 32 && !b.between?(9, 13)}
    else
      ONLY_SPACE_UNICODE_RE == str
    end
  end
end

puts OnlySpace.only_space?("\r\n \t")

puts <<-EOS.strip_heredoc

extendを使って、既存インスタンスを拡張
==============================================================
EOS

module OnlySpace
  def only_space?
    OnlySpace.only_space?(self)
  end
end

str = "Yo Ho!"

str.extend(OnlySpace)

puts str.only_space?

puts <<-EOS.strip_heredoc

委譲（Forwardable）を使ってStringクラスを拡張
============================================================
EOS
require "forwardable"

class StringExtra
  extend Forwardable

  ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

  def_delegators(:@string, *String.public_instance_methods(false))

  p self.instance_methods(false)

  def initialize(str="")
    @string = str
  end

  def only_space?
    if @string.ascii_only?
      !@string.bytes.any? { |b| b != 32 && !b.between?(9, 13)}
    else
      ONLY_SPACE_UNICODE_RE == @string
    end
  end
end

str = StringExtra.new("TEST TEST")

puts str
puts str.only_space?

str = StringExtra.new(" \r\n \t ")
str = str.reverse       # 残念ながらStringExtraではなくStringインスタンスが返却されてくる
# puts str.only_space?    # NoMethodError

puts <<-EOS.strip_heredoc

Refinementsを使ってモンキーパッチを当てる
======================================================
EOS

module OnlySpace3
  refine String do
    ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

    def only_space?
      if self.ascii_only?
        !self.bytes.any? { |b| b != 32 && !b.between?(9, 13)}
      else
        ONLY_SPACE_UNICODE_RE == self
      end
    end
  end
end

class Person
  # Personクラスの中でのみモンキーパッチが有効！
  using OnlySpace3

  def initialize(name)
    @name = name
  end

  def valid?
    !@name.only_space?
  end

  def display(io=$stdout)
    io.puts(@name)
  end
end

person = Person.new("ヤマダ")

puts person.valid?

person.display

class PersonDerived < Person
  def blanky?
    # 基底クラスでのusingが派生クラスには影響を及ぼさない！
    @name.nil? || @name.only_space?      # -> NoMethodError
  end
end

pd = PersonDerived.new("大輔")

puts pd.blanky?