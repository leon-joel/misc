# CodeIQ 数学の問題をプログラミングで解こう！「トライアングル・メイズ」問題解説
#   https://codeiq.jp/magazine/2016/10/45900/

def calc(n)
  f = 1

  2.upto n do |i|
    f = ( f * (f+1) ) % 1000003
    # puts "#{i}: #{f}"
  end

  ans = f
  puts "Ans. #{ans}"
end


def find_pattern(n)
  f = 1

  h = { 1 => 1 }
  2.upto n do |i|
    f = ( f * (f+1) ) % 1000003
    # puts "#{i}: #{f}"

    if h.has_key?(f)
      puts "FOUND!!! i:#{i} f:#{f} last:#{h[f]}"

      # 214以降 955(=i-last)周期 でループすることが分かる
      break
    else
      h[f] = i
    end

  end

  ans = f
  puts "Ans. #{ans}"

  p h
end

def calc_by_pattern(n)
  if 214 < n
    # 214以上なら飛び出した差分を計算し、
    # それを 955 で割った余りを 214 に足し
    # それを n として計算する

    n = 214 + (n - 214) % 955
  end

  calc n
end


# simple 10

# find_pattern 2500


calc_by_pattern 10000000
