require 'active_support/core_ext/string/strip'


module Printable
  def print
    puts 'Print (Printable)'
  end

  def prepare_cover
    puts 'Prepare Cover (Printable)'
  end
end

module Document
  def print_to_screen
    prepare_cover
    format_for_screen
    print
  end

  def format_for_screen
    # puts 'Format for Screen'
  end

  def print
    puts 'Print (Document)'
  end
end

module Prep1
  def print
    puts 'ENTER (Prep1)'
    super
    puts 'LEAVE (Prep1)'
  end
end
module Prep2; end

class Book
  # includeすると、Bookクラスのすぐ上に挿入される。
  # ★includeはクラスに対して新たな機能を提供する場合に利用する。

  include Document  # Bookのすぐ上に挿入される
  include Printable # Bookのすぐ上に挿入される


  # prependすると、Bookクラスのすぐ下に挿入され、かつそのクラス（モジュール）がメソッド探索順の起点となる。
  # ★prependすることによりクラス自身のメソッドを上書きできるので、
  #   prependはクラスに既に存在する機能を変更するために利用できる。
  #   ※ActiveSupportのalias_method_chainと同じ事がよりスマートに（？）実現できる。
  #
  # http://www.techscore.com/blog/2013/01/22/ruby2-0%E3%81%AEmodule-prepend%E3%81%AF%E5%A6%82%E4%BD%95%E3%81%AB%E3%81%97%E3%81%A6alias_method_chain%E3%82%92%E6%92%B2%E6%BB%85%E3%81%99%E3%82%8B%E3%81%AE%E3%81%8B%EF%BC%81%EF%BC%9F/
  # http://techracho.bpsinc.jp/baba/2013_02_24/6536
  #

  prepend Prep1   # Bookのすぐ下に挿入される
  prepend Prep2   # Prep1のすぐ下に挿入される
end

class Book2 < Book
  def print
    puts 'Print (Book2)'
  end
end


puts
puts <<-'EOS'.strip_heredoc
クラス継承階層 ★メソッド探索は下から上に！！
       BasicObject
       Kernel
       Object
       Document   ←includeによって挿入(1)
       Printable  ←includeによって挿入(2)
       Book
       Prep1      ←prependによって挿入(1)
  b -> Prep2      ←prependによって挿入(2) ★bがBookではなく、最後にprependしたPrep2を指していることに注目！
       Book2
EOS

puts
b = Book.new
b.print_to_screen

puts 'Book継承順'
p Book.ancestors

puts 'Book2継承順'
p Book2.ancestors