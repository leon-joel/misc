# 累乗の計算
i = 1
accum = 1
while i <= 4
  accum = accum * i
  i = i + 1
end
p(accum)
p()

# prime numbers

i = 2
while i <= 100
  # p(i)
  j = 2
  devisor = 0
  while j <= i / 2
    if i % j == 0
      devisor = devisor + 1 # 約数をカウント
      j = i   # breakを実装していないので、breakの代わりにjを増やしてしまう
    end
    j = j + 1
  end

  if devisor == 0
    # 約数がなかった＝素数
    p(i)
  end

  i = i + 1
end