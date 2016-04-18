require 'pp'
# require 'logger'
# require 'active_support/core_ext/string'          # for String.first
require 'active_support/core_ext/string/strip'  # for strip_heredoc


puts <<-EOS.strip_heredoc

定数のはずなのに削除できてしまう！これがRuby！
=========================================================
EOS

module Defaults
  NETWORKS = ["192.168.1", "192.168.2"]
  # NETWORKS = ["192.168.1", "192.168.2"].freeze
end

def purge_unreachable(networks=Defaults::NETWORKS)
  networks.delete_if do |net|
    # !ping(net + ".1")
    true
  end
end


p Defaults::NETWORKS      # -> ["192.168.1", "192.168.2"]

purge_unreachable

p Defaults::NETWORKS      # -> []


puts <<-EOS.strip_heredoc

配列をfreezeしただけではダメ～
=========================================================
EOS

module Defaults2
  NETWORKS = ["192.168.1", "192.168.2"].freeze
end

def host_addresses(host, networks=Defaults2::NETWORKS)
  networks.map { |net| net << ".#{host}" }
end


p Defaults2::NETWORKS      # -> ["192.168.1", "192.168.2"]

host_addresses("1")

p Defaults2::NETWORKS      # -> []


puts <<-EOS.strip_heredoc

要素もFreezeすればOK！ ただし面倒くさい上に可読性も落ちるが…
=========================================================
EOS

module Defaults3
  NETWORKS = [
      "192.168.1",
      "192.168.2"
  ].map!(&:freeze).freeze

  TIMEOUT = 5
end

p Defaults3::NETWORKS      # -> ["192.168.1", "192.168.2"]

begin
  host_addresses("2", Defaults3::NETWORKS)  # => #<RuntimeError: can't modify frozen String>
rescue RuntimeError => e
  p e
end

p Defaults3::NETWORKS      # -> ["192.168.1", "192.168.2"]


puts <<-EOS.strip_heredoc

でも配列自体をすげ替えることが出来るので、
Module自体もfreezeしないといけない！
=========================================================
EOS

puts "すげかえる…"
Defaults3::NETWORKS = ["t1".freeze, "t2".freeze].freeze

puts "module自体をfreezeすると"
Defaults3.freeze

puts "すげ替えようとするとエラーができるようになる"
begin
  Defaults3::NETWORKS = ["e1", "b1", "m1"]    # => can't modify frozen Module (RuntimeError)
rescue RuntimeError => e
  p e
end

begin
  Defaults3::TIMEOUT += 5                     # => can't modify frozen Module (RuntimeError)
rescue RuntimeError => e
  p e
end
