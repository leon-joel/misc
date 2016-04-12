#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'
require 'benchmark'

# block ⇒ Proc
def pass(&block) block; end

p g = pass { |name| "Hello #{name}"}    # -> #<Proc:0x2af9e28@C.....>


# Blockには2引数渡すことになっているが…
def test
  yield("a", "b")
end

# Procは引数の数があっていなくてもエラーなく呼び出される

# Proc側は3引数を期待している
p xyz = test { |x, y, z| [x, y, z] }    # -> ["a", "b", nil]  ※足りない部分には自動的にnilがセットされる
# こちらは0引数を期待
p test {"b"}                            # -> "b"              ※余っている部分は切り捨てられる

# lambdaの場合は引数の数が違うとArgumentErrorが発生する
func = -> (x) { "Hello #{x}"}
begin
  func.call("a", "b")                      # -> wrong number of arguments (2 for 1) (ArgumentError)
rescue ArgumentError => e
  p e
end


puts <<-EOS.strip_heredoc

lambdaかどうかを判定
=======================================================
EOS

def test_with_block(&block)
  block.lambda?
end

puts "Procを与える"
puts test_with_block { |x| x }      # -> false

puts "lambdaを与える"
puts test_with_block(& ->(x){x} )   # -> true


puts <<-EOS.strip_heredoc

渡されたBlockが必要とする引数の数をチェック
===========================================================
EOS

class Stream
  def initialize(io=stream, chunk=64*1024)
    @io, @chunk = io, chunk
  end

  def stream(&block)
    loop do
      start = Time.now
      data = @io.read(@chunk)
      data
      return if data.nil?

      # blockが必要とする引数の数をチェックして
      arg_count = block.arity
      arg_list = [data]

      # 2個目が必要ならそれを追加して
      if arg_count == 2 || ~arg_count == 2
        arg_list << (Time.now - start).to_f
      end

      # blockに渡す
      block.call(*arg_list)
    end
  end
end

# 可変長引数を取る場合（デフォルト引数を含む場合）、arityは負の数を返す。
# その数の「1の補数」を取ると、必須引数の数が分かるようになっている。
func = -> (x, y=1) { x + y }
puts "引数: #{func.arity}"          # -> -2
puts "（1の補数）: #{~func.arity}"   # -> 1  ＝必須引数の数

def file_size(file)
  File.open(file) do |f|
    bytes = 0
    elapsed = 0

    s = Stream.new(f)
    s.stream do |data, split|
      bytes += data.size
      elapsed += split
    end

    puts "所要時間: #{elapsed}"
    bytes
  end
end


# s = file_size("../.idea/workspace.xml")
puts filepath = "#{ENV['USERPROFILE']}/install.iso"
s = file_size(filepath)
puts "#{s} bytes"


puts <<-EOS.strip_heredoc

SHA256ハッシュ値計算
==============================================================
EOS

require "digest"

def digest(file)
  File.open(file) do |f|
    sha = Digest::SHA256.new
    s = Stream.new(f)

    # updateメソッドは引数を1つしか受け取らない。
    # streamメソッドはそれに合わせて、必要な数の引数を渡してくれる。
    # ※MethodオブジェクトはProcとは違い引数の数を厳密に合わせないとエラーとなるので、
    #   stream側の実装で引数の数をチェックするようにした。
    s.stream(&sha.method(:update))
    sha.hexdigest
  end

end

sha = digest("../curry.rb")
puts "SHA256: #{sha}"


puts <<-EOS.strip_heredoc

突然ですが、Benchmarkを試してみます！
===========================================================
EOS

array = (1..500000).map { rand }

puts "リハーサルあり"
Benchmark.bmbm do |x|
  x.report("Sort!") { array.dup.sort! }
  x.report("Sort")  { array.dup.sort }
end

puts
puts "リハーサルなし"
Benchmark.bm(10) do |x|
  x.report("Sort!") { array.dup.sort! }
  x.report("Sort")  { array.dup.sort }
end