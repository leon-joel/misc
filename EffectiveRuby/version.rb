#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'
require 'benchmark'



class Version
  attr_reader :major, :minor, :patch

  def initialize(version)
    @major, @minor, @patch = version.split('.').map(&:to_i)
  end
end

p vs = %w(1.0.0 1.11.1 1.9.0).map {|v| Version.new(v)}

begin
  vs.sort   # 比較メソッドを実装していない（デフォルトの実装がnilを返す）場合はエラーが発生する。
            # -> comparison of Version with Version failed (ArgumentError)
rescue => e
  p e
end

puts <<-EOS.strip_heredoc

<=> 演算子を実装する
EOS

class Version
  def <=> (other)
    return nil unless other.is_a?(Version)

    # detectは条件にマッチするものが見つかったらそれを返す。
    # 見つからなかったらnilを返すので、その場合は 0 を返すようにしている。
    [ major <=> other.major,
      minor <=> other.minor,
      patch <=> other.patch,
    ].detect { |n| !n.zero? } || 0
  end
end

p vs.sort

puts <<-EOS.strip_heredoc

比較演算子を実装する（Comparableをinclude）
EOS

class Version
  include Comparable
end

p a = Version.new('2.1.1')
p b = Version.new('2.10.3')
p [a > b, a >= b, a < b, a <= b, a == b]

p Version.new('2.8.0').between?(a, b)

puts <<-EOS.strip_heredoc

ハッシュのキーに使用できるようにする
・eql?メソッドを実装
・hashメソッドを実装
EOS

class Version
  alias_method :eql?, :==

  def hash
    # ハッシュ関数として最適なものとは言えないかもしれないがとりあえずこれで…
    [major, minor, patch].hash
  end
end

p h = { a => 'value a', b => 'value b', Version.new('2.8.0') => 'value 2.8', Version.new('2.1.1') => 'value 2.1.1 same as a' }
# a => 'value a' が4番目のキーによって上書きされていることが分かる。
