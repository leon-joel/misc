def monthly_sales
  110   # 実際にはDBから読み取ったりするところ
end

# 各イベント共通の変数
target_sales = 100

event '常に発生するイベント' do
  true
end

event '絶対に発生しないイベント' do
  false
end

# eventに渡されるBlockはトップレベルのローカル変数とメソッドを共有している
event '月間売り上げが驚くほど高い' do
  target_sales < monthly_sales
end

event '月間売り上げが底なしに低い' do
  monthly_sales < target_sales
end