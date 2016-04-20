# require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc

class Tuner
  def initialize(presets)
    @presets = presets
    # ★dupすればオリジナルは書き換わらない！
    #   注意！dupすると、freeze状態はコピーされない。（cloneはされる）
    #         dupすると、特異メソッドはコピーされない。（cloneはされる）
    # @presets = presets.dup
    clean
  end

  private

  def clean
    # 有効な周波数は末尾が奇数
    @presets.delete_if { |f| f[-1].to_i.even? }
  end
end

p presets = %w(90.1 106.2 88.5)
p tuner = Tuner.new(presets)

p presets     # ★オリジナルの配列が変更されてしまっている！

puts <<-EOS.strip_heredoc

オリジナルの配列を変更してしまわないよう改良した
=========================================================
EOS

class Tuner2
  def initialize(presets)
    @presets = clean(presets)
  end

  private

  def clean(presets)
    # 偶数要素だけをrejectした新しい配列を返す
    presets.reject { |f| f[-1].to_i.even? }
  end
end

p presets = %w(90.1 106.2 88.5)
p tuner = Tuner2.new(presets)

p presets     # ★オリジナルの配列が変更されてしまっている！


