#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'


module LogMethod
  ## aliasするメソッド
  def log_method(method)
    orig = "#{method}_without_logging".to_sym

    if instance_methods.include?(orig)
      raise NameError, "#{orig}はユニークな名前ではありません。"
    end

    # オリジナルのメソッドを退避（_without_logging を付加）
    alias_method(orig, method)

    # オリジナルのメソッドをオーバーライド
    define_method(method) do |*args, &block|
      $stdout.puts "calling method '#{method}'"
      result = send(orig, *args, &block)
      $stdout.puts "'#{method}' returned #{result.inspect}"
      result
    end
  end

  ## aliasを取り消すメソッド
  def unlog_method(method)
    orig = "#{method}_without_logging".to_sym

    if !instance_methods.include?(orig)
      raise NameError, "#{orig}は既に削除されています（存在していません）。"
    end

    remove_method(method)

    alias_method(method, orig)

    remove_method(orig)
  end
end

[1,2,3].first       # -> 1



Array.extend(LogMethod)
Array.log_method(:first)

[1,2,3].first       # -> 1      ※ログ出力付き
%w(1, 2, 3).first   # -> "1"    ※ログ出力付き

p %w(a b c).first_without_logging # -> "a"

Array.unlog_method(:first)

p %w(x y z).first

# p %w(a b c).first_without_logging # NoMethodError
