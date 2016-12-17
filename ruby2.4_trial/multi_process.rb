# http://qiita.com/masashi127/items/b186bbf20b4c9632cc86#%E6%A4%9C%E8%A8%BC


require "parallel"
require 'benchmark'
require "securerandom"

# シングルスレッド版
def random_with_single_thread
  puts __method__

  exec_time = Benchmark.realtime do
    [*1..10].each do |i|
      100000.times do |ii|
        Digest::MD5.digest(SecureRandom.uuid)
      end
    end
  end

  puts "exec_time: #{exec_time}"
end

# マルチスレッド版
def random_with_multi_thread
  puts __method__

  id = 0
  count = 0

  exec_time = Benchmark.realtime do

    Parallel.each([*1..10], in_threads: 4) {|i|
      id = i

      100000.times do |ii|
        if id != i
          count += 1
        end
        id = i
        Digest::MD5.digest(SecureRandom.uuid)
      end
    }
  end

  puts "exec_time: #{exec_time}"
  puts "count    : #{count}"
end

# マルチプロセス版 ★Windowsではマルチプロセスにならず、シングルプロセス・シングルスレッドで実行されてしまう
def random_with_multi_process
  id = 0
  count = 0

  exec_time = Benchmark.realtime do

    # 4プロセスで実行する ★Windowsでは fork が出来ない???らしく、右のメッセージが表示される ⇒Process.fork is not supported by this Ruby
    Parallel.each([*1..10], in_processes: 4) {|i|
      id = i

      100000.times do |ii|
        if id != i
          count += 1
        end
        id = i
        Digest::MD5.digest(SecureRandom.uuid)
      end
    }
  end
  puts "exec_time: #{exec_time}"
  puts "count    : #{count}"
end

# random_with_single_thread
# exec_time: 9.59939019400008

# random_with_multi_thread
# exec_time: 9.966401882000355    # シングルと殆ど変わらない
# count    : 970                  # スレッド切り替えは970回も発生している

# ★マルチスレッド版をRubyMineの『Run』で2回連続で実行すると以下のエラーが発生する！！！ なんで？？？RubyMineの『Terminal』だと問題ない。
#   multi_process.rb:40:in `digest': Digest::Base cannot be directly inherited in Ruby (RuntimeError)

random_with_multi_process
# Process.fork is not supported by this Ruby
# exec_time: 9.885854475000087    # シングルと殆ど変わらない
# count    : 0                    # スレッド切り替えが全く発生していない＝シングルスレッドで実行されているようだ