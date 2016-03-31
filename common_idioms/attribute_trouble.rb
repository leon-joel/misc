require 'active_support/core_ext/string/strip'

class MyClass
  attr_accessor :my_attribute

  def set_attribute(n)
    # my_attribute = n       # ここでセットしているのはローカル変数
    # @my_attribute = n      # ここでセットしているのはインスタンス変数
    self.my_attribute = n  # selfを使ってインスタンス変数を明示的に指定することも出来る
  end
end



obj = MyClass.new
p obj.private_methods(false)    # -> []
p obj.public_methods(false)     # -> [:my_attribute, :my_attribute=, :set_attribute]


obj.set_attribute 10
p obj.my_attribute


puts <<-EOS.strip_heredoc

★ここでsetterをprivateに変更している！
privateメソッドは明示的なレシーバーを付けて呼び出せないことになっているが、
attributeのセッターだけはその例外とされていて、明示的なレシーバー付きでも呼び出せる。
EOS


class MyClass
  private :my_attribute=
end


p obj.private_methods(false)    # -> [:my_attribute=]
p obj.public_methods(false)     # -> [:my_attribute, :set_attribute]


obj.set_attribute 11
p obj.my_attribute    # -> nil

