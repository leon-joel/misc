require 'mrproper'
require_relative '../version'


class Version
  def to_s
    puts ret = [@major, @minor, @patch].join('.')
    ret
  end
end

properties("Version") do
  # data([Integer, Integer, Integer])   # -500..500 の整数（3要素のの配列）が生成される ※この範囲が何とも言えない…
  data([0, 0, 0])
  data([1, 1, 1])
  data([(0..100000), (0..100000), (0..100000)])

  property("new(str).to_s == str") do |data|
    str = data.join('.')
    assert_equal(str, Version.new(str).to_s)
  end

  property("compare") do |data|
    str = data.join('.')
    zero = Version.new('0.0.0')
    assert_operator zero, :<=, Version.new(str)
  end
end