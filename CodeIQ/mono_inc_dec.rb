# 単調増加で単調減少な数
# https://codeiq.jp/challenge/2989


NUMS = "0123456789ABCDEF".chars.freeze


# max数が m で d 桁の減少数を文字列で列挙【再帰】
def dec_num_d(m, d, &block)
  return to_enum(__method__, m, d) unless block_given?

  # 例） max=2, d=2 の場合 21, 20, 10
  # 例） max=2, d=3        210
  # 例） max=3, d=1        3, 2, 1, 0
  # 例） max=3, d=2        32, 31, 30, 21, 20, 10
  # 例） max=3, d=3        321, 320, 210
  # 例） max=4, d=3        432, 431, 430, 421, 420, 321, 320, 210

  if d == 1
    # m, m-1, m-2, ..., 0
    m.downto 0 do |n|
      block.call NUMS[n]
    end
    return
  end

  if m < d
    a = (0..m).to_a.reverse.inject("") { |acc, n| acc << NUMS[n] }
    block.call a
    return
  end

  m.downto m-(m-d+1) do |n|
    dec_num_d(n-1, d-1) do |a|
      block.call "#{NUMS[n]}#{a}"
    end
  end
end

# base進数の単純減少数を大きい方から数値で列挙
def dec_num(base, &block)
  return to_enum(__method__, base) unless block_given?

  # 桁数でループ
  base.downto 1 do |d|
    dec_num_d(base-1, d) { |a| block.call a.to_i(base) }
  end
end

# base進数の最大単純増加数
def calc_inc_max(base)
  (1..base-1).inject(0) { |acc, n| (acc * base) + n }
end

# numを基数baseで表した時に単純増加数となっている？
def is_inc_num(base, num)

  str = num.to_s(base)
  # puts str

  last = 0
  str.each_char do |a|
    cur = a.ord
    return false if cur <= last

    last = cur
  end
  true
end

# 単純減少数＝単純増加数 となる数値を返す
# 見つからなかったら nil を返す
def find_dec_inc(base_inc, base_dec)
  # puts "#{base_inc} - #{base_dec}"

  # 単純増加数のMAXを計算
  max_inc = calc_inc_max(base_inc)

  # 単純減少数を大きな方から数値で列挙
  dec_num(base_dec) do |num|
    # puts "#{num.to_s(base_dec)} => #{num}"
    next if max_inc < num
    return num if is_inc_num(base_inc, num)   # 見つかった
  end

  nil   # 見つからなかった（これはあり得ない）
end


# calc_maximums base1, base2

# enum_dec_nums 4

# dec_num_d(4, 3).each { |a| puts a }
# e = dec_num_d(4, 2)
# p e
# e.with_index do |v, i|
#   puts "#{i}: #{v}"
# end



# dec_num(12).map {|num| num.to_s(12) }.each do |s|
#   puts s
# end

# puts (0..12).to_a.reverse.inject("") { |acc, n| acc << NUMS[n] }

# num = "0123456789ABCDEF".to_i(16)
# puts is_inc_num(16, num)

# num = "0123456".to_i(7)
# puts is_inc_num(7, num)

# num = calc_inc_max(16)
# puts "#{num}: #{num.to_s(16)}"


# p (0..1).to_a.reverse.join

### 気の利いた入出力
# print "Input 2 nums: "
# str = $stdin.gets
# a, b = str.split(" ", 2)
# base1 = a.to_i
# base2 = b.to_i
# puts "B1: #{base1}, B2: #{base2}"
#
# ans = find_dec_inc(base1, base2)
# if ans.nil?
#   puts "見つからなかった（これはあり得ない）"
# else
#   puts "FOUND! #{ans}"
#   puts "  #{base1}進数 単純減少数 #{ans.to_s(base1)}"
#   puts "  #{base2}進数 単純増加数 #{ans.to_s(base2)}"
# end

### シンプル入出力
str = $stdin.gets
a, b = str.split(" ", 2)
base1 = a.to_i
base2 = b.to_i

print find_dec_inc(base1, base2)
