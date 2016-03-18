require 'active_support/core_ext/string/strip'


puts <<-EOS.strip_heredoc

さらにメソッドラッパー【Refinementsラッパー】
======================================================
EOS

module StringRefinements
  refine String do
    def length
      p self                            # -> "War and Peace"
      p self.class                      # -> String
      p self.singleton_class            # -> #<Class:#<String:0x3739650>>
      p self.singleton_class.ancestors  # -> [#<Class:#<String:0x3739650>>, String, Comparable, Object, Kernel, BasicObject]

      5 < super ? 'Long' : 'Short'
    end
  end
end

puts "War and Peace".length   # -> 13

using StringRefinements       # これ以降（ファイルの最後 or Module定義の終わりまで）Refinementsが適用される

puts "War and Peace".length   # -> Long