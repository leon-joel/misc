Thread.current.name = "MainThread!"
z = Thread.new{Thread.stop}
z.name = "zzzz"
sleep 1   # ここで少し待ち時間を入れると
p z       # zスレッドが sleep状態になる

a, b = Thread.new { b.join }, Thread.new { a.join }
a.name = "aaaaa"
b.name = "bbbbb"
sleep 1   # ここで少し待ち時間を入れると
p a       # a,bスレッドが sleep状態になる
p b
Thread.kill(a)

sleep 1
p a       # aをkillしたので、dead状態になる
p b       # b は処理を終了したので、やはりdead状態になる
p Thread.current
z.join    # ここで deadlock

p Thread.current
