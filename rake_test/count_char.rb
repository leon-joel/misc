# count_char.rb

# 文字ごとの出現回数を集計
def count_char(val)
  table = Hash.new(0)

  val.split(//).each do |ch|
    table[ch] += 1
  end

  table.sort
end