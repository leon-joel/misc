require 'active_support/core_ext/string/strip'

puts <<-EOS.strip_heredoc
3つ目のメソッドラッパー【Prependラッパー】
=================================================
EOS

module ExplicitString
  def length
    p self                            # -> "War and Peace"
    p self.class                      # -> String
    p self.singleton_class            # -> #<Class:#<String:0x37351f8>>
    p self.singleton_class.ancestors  # -> [#<Class:#<String:0x37351f8>>, ExplicitString, String, Comparable, Object, Kernel, BasicObject]

    5 < super ? 'LONG' : 'SHORT'
  end
end

String.class_eval do
  puts "prependによりStringよりも下（メソッド探索順位的には上位）にクラスを挿入"
  prepend ExplicitString
end

# 対象クラスが固定なら以下のように書いた方が自然かな
# class String
#   prepend ExplicitString
# end


puts "War and Peace".length   # -> 13


puts <<-EOS.strip_heredoc

メソッドラッパーを使って、ロギングと例外処理を実装
=================================================================
EOS

class Amazon
  def reviews_of(book)
    puts "Amazon#reviews_of: ENTER"
    [ "Good job!", "Nice work!", "Super!", "So bad!!!", "Awesome!" ]
  end
end

module AmazonWrapper
  def reviews_of(book)
    puts "AmazonWrapper#reviews_of: ENTER"
    start = Time.now
    result = super
    time_taken = Time.now - start
    puts "reviews_of() took more than #{time_taken} seconds" if 2 < time_taken
    puts "AmazonWrapper#reviews_of: LEAVE"
    result
  rescue
    puts "reviews_of() failed."
    []
  end
end

Amazon.class_eval do
  prepend AmazonWrapper
end

amazon = Amazon.new

amazon.reviews_of("Just Do It!")


puts <<-EOS.strip_heredoc

alias_methodを使って演算子をぶっ壊す！
=======================================================
EOS
class Fixnum
  alias_method :old_plus, :+

  def +(value)
    p self        # -> 1
    p self.class  # -> Fixnum
    # p self.singleton_class
    self.old_plus(value).old_plus(1)
  end
end

puts 1+1    # -> 3