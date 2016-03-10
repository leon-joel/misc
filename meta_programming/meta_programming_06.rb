

# 空のクラス Rabbit を定義
class Rabbit; end


# 「Rabbitクラスのオブジェクト」ではなく
# 「Rabbitクラス自体」に特異メソッドを定義している
def Rabbit.colors
  [:black, :brown, :white, :mixed]
end

p Rabbit.colors
puts


puts "=== クラスメソッドおよびインスタンスメソッドの定義 ==="

class Jabbit
  # インスタンスメソッドの定義 ※ Jabbit.new.colors で呼び出せる
  def colors
    p self          # -> <Jabbit:0xnnnnnn>
    p self.class    # -> Jabbit     ※Jabbitクラスのインスタンス だということを示している
    [:yellow, :black, :white]
  end

  # クラスメソッドの定義 ※ Jabbit.colors で呼び出せる
  #
  # ★必ず理解すること！
  #   クラスメソッド＝「JabbitというClassクラスのインスタンス」に定義した特異メソッド である
  #
  def self.colors
    p self          # -> Jabbit
    p self.class    # -> Class      ※Classクラスのインスタンス だということを示している
    [:black, :orange, :cream, :aqua]
  end

  # クラスメソッドの定義 【特異クラス内に定義】
  class << self   # この記法で 「特異クラスをOPEN」している
    def roar
      "wow (特異メソッド）"
    end
  end

  # インスタンスメソッドの定義
  def roar
    "bow （インスタンスメソッド）"
  end

end


p Jabbit.public_methods(false)
p Jabbit.public_instance_methods(false)

puts
puts "インスタンスメソッドの呼び出し"
p Jabbit.new.colors

puts
puts "クラスメソッドの呼び出し"
p Jabbit.colors


puts
puts "インスタンスメソッドの呼び出し2"
puts Jabbit.new.roar

puts
puts "クラスメソッドの呼び出し2【特異クラス内に定義】"
puts Jabbit.roar
