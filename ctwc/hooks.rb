#
# フックメソッド
#

class String
  def self.inherited(subclass)
    puts "#{self} は #{subclass} に継承された"
  end
end

class MyString < String; end


module M1
  def self.included(other)
    puts "M1 は #{other} にインクルードされた"
  end
end

module M2
  def self.prepended(other)
    puts "M2 は #{other} にプリペンドされた"
  end
end

class C
  include M1
  prepend M2

  p self.ancestors  # -> [M2, C, M1, Object, Kernel, BasicObject]
end


module M
  def self.method_added(method)
    puts "新しいメソッド M##{method}"
  end

  def my_method; end

  p self.methods
  p self.instance_methods(false)
end