#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'
require 'benchmark'

module A
  def who_am_i?
    "A#who_am_i?"
  end
end

module B
  def who_am_i?
    "B#who_am_i?"
  end
end

class C
  include A
  include B

  def who_am_i?
    "C#who_am_i?"
  end
end

p C.ancestors         # -> [C, B, A, Object, Kernel, BasicObject]

puts C.new.who_am_i?  # -> C#who_am_i?



class D
  prepend A
  prepend B

  def who_am_i?
    "D#who_am_i?"
  end
end

p D.ancestors         # -> [B, A, D, Object, Kernel, BasicObject]  ★順序が入れ替わっている！

puts D.new.who_am_i?  # -> B#who_am_i?                             ★呼び出されるメソッドも変わっている！
