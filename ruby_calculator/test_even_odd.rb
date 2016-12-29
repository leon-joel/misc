# 相互再帰
def even?(n)
  if n == 0
    true
  else
    odd?(n - 1)
  end
end

def odd?(n)
  if n == 0
    false
  else
    even?(n - 1)
  end
end

p(even?(3))
p(odd?(3))