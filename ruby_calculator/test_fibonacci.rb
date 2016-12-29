# フィボナッチ数列のN番目の数字を求める
def fib(x)
  if x <= 1
    x
  else
    fib(x - 1) + fib(x - 2) # 再帰呼び出し
  end
end

p(fib(10))
