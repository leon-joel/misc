setup do
  puts '空の高さ設定'
  @sky_height = 100
end

setup do
  puts '山の高さを設定'
  @mountain_height = 200
end

event '空が落ちてくる' do
  @sky_height < 300
end

event '空が近づいている' do
  @sky_height < @mountain_height
end

event 'もうダメだ… 手遅れ' do
  @sky_height < 0
end
