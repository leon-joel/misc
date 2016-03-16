# トップレベルのインスタンス変数を削除するために、スコープをフラット化する。
lambda {
  setups = []
  events = []


  # セットアップBlockの登録
  Kernel.send :define_method, :setup do |&block|
    setups << block
  end

  # イベント名と発火条件を登録
  Kernel.send :define_method, :event do |description, &block|
    events << { description: description, condition: block}
  end

  # each_setupメソッド
  Kernel.send :define_method, :each_setup do |&block|
    setups.each do |setup|
      block.call setup
    end
  end

  # each_eventメソッド
  Kernel.send :define_method, :each_event do |&block|
    events.each do |event|
      block.call event
    end
  end
}.call    # ラムダを即実行

load 'events2.rb'


# 全てのイベントに対して、受け取ったBlock（＝each_setup()＋ALERT表示）をcallする。
each_event do |event|
  # イベントごとにクリーンルームを用意する
  # mainを汚さないため、event同士が変数を共有しないようにするため。
  env = Object.new

  # 全てのsetupに対して、受け取ったBlock（setup.call）を実行する
  # ★lambda内のローカル変数にアクセス出来るようにする為にこんな面倒くさいことをしている。
  each_setup do |setup|
    env.instance_eval &setup
  end

  p env

  puts "ALERT: #{event[:description]}" if env.instance_eval &(event[:condition])
  puts

end


p self                        # -> main
p self.instance_variables     # -> []  ★トップレベルに変数が漏れ出していない

# dummy = "yamada"
p self.send :local_variables  # -> []  ★同上


