# セットアップBlockの登録
def setup(&proc)
  @setups << proc
end

# イベント名と発火条件を登録
def event(description, &proc)
  @events << { description: description, condition: proc}
end


# トップレベルのインスタンス変数 ※グローバル変数に近いのであまりよろしくない
@setups = []
@events = []

load 'events2.rb'



@events.each do |event|
  @setups.each do |setup|
    setup.call
  end

  puts "ALERT: #{event[:description]}" if event[:condition].call
end