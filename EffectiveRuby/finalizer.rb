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


# str = "abc"
# 100000.times do |i|
#   str += i.to_s
#
#   s = str.first(20)
#   puts "#{s.object_id}: #{s}" if i % 1000 == 0
# end


puts "END"

pp GC.stat

puts
puts