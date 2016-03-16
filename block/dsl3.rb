# トップレベルのインスタンス変数を削除するために、スコープをフラット化する。
lambda {
  setups = []
  events = []


  # セットアップBlockの登録
  Kernel.send :define_method, :setup do |&proc|
    setups << proc
  end

  # イベント名と発火条件を登録
  Kernel.send :define_method, :event do |description, &proc|
    events << { description: description, condition: proc}
  end

  # each_setupメソッド
  Kernel.send :define_method, :each_setup do |&proc|
    setups.each do |setup|
      proc.call setup
    end
  end

  # each_eventメソッド
  Kernel.send :define_method, :each_event do |&proc|
    events.each do |event|
      proc.call event
    end
  end
}.call    # ラムダを即実行

load 'events2.rb'

# 全てのイベントに対して、受け取ったBlock（＝each_setup()＋ALERT表示）をcallする。
each_event do |event|
  # 全てのsetupに対して、受け取ったBlock（setup.call）を実行する
  # ★lambda内のローカル変数にアクセス出来るようにする為にこんな面倒くさいことをしている。
  each_setup do |setup|
    setup.call
  end

  puts "ALERT: #{event[:description]}" if event[:condition].call
end


p self                        # -> main
p self.instance_variables     # -> [:@sky_height, :@mountain_height]


