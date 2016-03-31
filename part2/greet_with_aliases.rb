require 'active_support/core_ext/string/strip'


module Greetings
  def greet
    "Hello"
  end
end

class MyClass
  include Greetings

end

puts MyClass.new.greet


class MyClass2 < MyClass
  def greet_with_enthusiasm
    "Hey, #{greet_without_enthusiasm}"
  end

  alias_method :greet_without_enthusiasm, :greet
  alias_method :greet, :greet_with_enthusiasm
end


puts MyClass2.new.greet


puts <<-EOS.strip_heredoc

オーバーライドによってアラウンドエイリアスと同じ事を実現
======================================================
EOS

module EnthusiasticGreetings
  include Greetings

  def greet
    "Hey, #{super}"
  end
end

class MyClass3
  include EnthusiasticGreetings
end

p MyClass3.ancestors
puts MyClass3.new.greet


puts <<-EOS.strip_heredoc

prependを使ったオーバーライド
ライブラリで提供されているアラウンドエイリアスをprependで使用する
=======================================================
EOS

module EnthusiasticGreetings2
  def greet
    "Hey, #{super}"
  end
end


class MyClass4
  # prependにしているので、まずmodule側のgreetが呼び出され、
  # そこからsuperでclass側のgreet（実際の処理が定義されている）が呼び出される
  prepend EnthusiasticGreetings2

  def greet
    "hello!"
  end
end

p MyClass4.ancestors
puts MyClass4.new.greet