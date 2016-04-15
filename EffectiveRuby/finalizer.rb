require 'pp'
require 'logger'
require 'active_support/core_ext/string'          # for String.first
# require 'active_support/core_ext/string/strip'  # for strip_heredoc

# 安全にリソース開放できるクラス設計。
# ただし、長期間リソースを保持したい場合があるので、
# このパターンだけでは対応出来ないこともある。
class SafetyResource
  def self.open(&block)
    resource = new
    block.call(resource) if block
  ensure
    resource.close if resource
  end

  def close

  end
end
SafetyResource.open() do |res|
  puts "Opened"
end


class ExtResource
  def open

  end
  def close
    puts "ExtResource#close"
  end
end

class Resource
  def initialize
    puts "Resource#initialize"
    @resource = allocate_resource
    finalizer = self.class.finalizer(@resource)

    # finalizerの登録
    # define_finalizerはBlockを渡すことも出来るようになっているが、
    # Block（Proc）でFinalizerを登録することは事実上困難（とのこと）。
    #  - http://docs.ruby-lang.org/ja/2.2.0/method/ObjectSpace/m/define_finalizer.html
    #  - EffectiveRuby p.185
    ObjectSpace.define_finalizer(self, finalizer)
  end

  def close
    puts "Resource#close"
    ObjectSpace.undefine_finalizer(self)
    @resource.close
  end

  def self.finalizer(resource)
    puts "get finalizer"
    -> (id) do
      # ※finalizerは確かに動作しているが、Coverageでは検出されないようだ。
      puts "run finalizer #{id}"
      resource.close
    end
  end

  def allocate_resource
    puts "Resource#allocate_resource"
    ExtResource.new
  end

  def run
    puts "Resource#run"
  end
end

begin
  res = Resource.new

  res.run
ensure
  puts "ensure"
  # res.close   # これをコメント化すると最後の最後に（ENDより後で）finalizerが呼び出される
end

puts <<-EOS.strip_heredoc

RubyProf
===========================================================
EOS

# require 'ruby-prof'
#
# RubyProf.start
#
# str = "abc"
# 10000.times do |i|
#   str += i.to_s
#
#   s = str.first(20)
#   puts "#{s.object_id}: #{s}" if i % 1000 == 0
# end
#
# result = RubyProf.stop
# printer = RubyProf::GraphPrinter.new(result)
# # printer = RubyProf::CallTreePrinter.new(result)
# printer.print(STDOUT, {})

puts "END"


puts <<-EOS.strip_heredoc

GC.stat
===========================================================
EOS
# Garbage Collector関連のSTATSをハッシュで取得出来る
# pp GC.stat

puts <<-EOS.strip_heredoc

オブジェクトのプロファイル
===========================================================
EOS
require 'objspace'

ObjectSpace.trace_object_allocations_start

GC.start

File.open("memory.json", "w") do |file|
  ObjectSpace.dump_all(output: file)
end

ObjectSpace.trace_object_allocations_stop


puts <<-EOS.strip_heredoc

MemoryProfiler
===========================================================
EOS
require 'memory_profiler'

report = MemoryProfiler.report do
  str = ""
  10.times do |i|
    str += i.to_s
  end
  puts str
end

report.pretty_print


puts
puts