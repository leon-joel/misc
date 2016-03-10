array = []

# arrayに特異メソッドを定義
def array.append_randomized_number
  self << rand(10)    # ここでのselfはarrayそのもの
end

# メソッドが定義されているかどうかを調べてみる
p array.respond_to?(:append_randomized_number)      # -> true
p Array.new.respond_to?(:append_randomized_number)  # -> false

# 特異メソッドの実行
10.times { array.append_randomized_number }
p array         # [x, x, .... , x]
p array.class   # -> Array
