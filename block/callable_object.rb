require 'active_support/core_ext/string/strip'

begin

  puts <<-'EOS'.strip_heredoc
  呼び出し可能オブジェクト
    ・Block  ★但し、Blockはオブジェクトではない
    ・Proc   ※Proc.newでブロックを渡し生成
    ・lambda ※Procの変形？
    ・Method

  EOS


  puts
  puts '===== Procオブジェクト ====='



  def check_lambda(p)
    return 'nilです！' if p.nil?
    return 'そもそもProcではありません！' unless p.is_a?(Proc)
    p.lambda? ? 'これはlambdaです' : 'これはProcです'
  end

  puts
  puts 'Proc.new'
  inc = Proc.new { |x| x + 1 }
  p inc
  puts check_lambda(inc)
  puts inc.call(2)  # -> 3

  puts
  puts 'lambda'
  dec = lambda { |x| x - 1 }
  p dec
  puts check_lambda(dec)
  puts dec.call(2)  # -> 1

  puts
  puts '-> lambda'
  inc2 = -> (x) { x + 1 }
  p inc2
  puts check_lambda(inc2)
  puts inc2.call(3) # -> 4

  puts
  puts '&修飾でブロックをProcに変換'
  def math(a, b)    # 【ブロック】を受け取りyieldで呼び出す

    # ブロックなしで呼び出すとエラーに #<LocalJumpError: no block given (yield)>

    return 'ブロックが与えられなかった！' unless block_given?

    yield(a, b)
  end

  def do_math(a, b, &operation) # 【ブロック】を受け取り、mathに渡す
    p operation             # -> Proc ★ &修飾によって、ブロックがProcに変換されている

    puts check_lambda(operation)
    math(a, b, &operation)  # ★ 再度&修飾することによって、Procをブロックに戻している
  end

  puts do_math(2, 3) { |x, y| x * y }
  puts do_math(2, 3)    # -> nil ★ブロックなしで呼び出すとエラーに #<LocalJumpError: no block given (yield)>


  puts <<-'EOS'.strip_heredoc

  ===== Procとlambda ～ returnの意味の違い =====

  EOS

  def double(callable_object)
    callable_object.call * 2
  end

  puts 'lambda内でのreturnは単にlambdaから呼び出し元に戻るだけ'
  l = lambda { return 10 }
  puts double(l)    # -> 20


  puts 'Proc内でのreturnはProcが定義されたスコープ（この場合は p が定義されたスコープ、つまり another_double） から戻ってしまう！'
  def another_double
    p = Proc.new { return 10 }  # 呼び出し元＝another_doubleからreturnしてしまう！
    result = p.call
    return result * 2   # ここまで来ない！
  end

  puts another_double      # -> 10


  puts 'トップレベルのスコープから戻ることは出来ないためLocalJumpErrorが発生する'
  p = Proc.new {return 10}
  # double(p)             # #<LocalJumpError: unexpected return>


  puts <<-'EOS'.strip_heredoc

  ===== Procとlambda ～ 引数チェックの違い =====

  EOS

  p = Proc.new {|a,b| [a, b] }
  puts p.arity            # -> 2

  p p.call(1, 2, 3)       # [1, 2]    ★引数が多い場合は自動的に切り落としてくれる
  p p.call(1)             # [1, nil]  ★少ない場合はnilを追加してくれる


  l = -> (a, b) { [a, b] }
  puts l.arity            # -> 2

  p l.call(1, 2)          # [1, 2]
  # p l.call(1, 2, 3)       # #<ArgumentError: wrong number of arguments (3 for 2)>
  # p l.call(1)             # #<ArgumentError: wrong number of arguments (1 for 2)>

  puts <<-'EOS'.strip_heredoc

  ===== Methodオブジェクト =====

  ブロック/Proc/lambdaは定義されたスコープで評価されるが、
  Method は所属するオブジェクトのスコープで評価される。
  Methodはオブジェクトに束縛されていると言える。
  但し、オブジェクトのスコープから引きはがし、他のオブジェクトに束縛することも可能

  EOS

  class MyClass
    def initialize(value)
      @x = value
    end

    def my_method
      @x
    end
  end

  object = MyClass.new(1)
  m = object.method :my_method
  p m             # -> #<Method: MyClass#my_method>
  puts m.call     # -> 1

  p = m.to_proc   # Procに変換できる
  p p             # -> #<Proc:0x3776a90 (lambda)>

  puts p.call     # -> 1  やはりオブジェクトに束縛されている


  puts <<-'EOS'.strip_heredoc

  ===== UnboundMethod =====
  元のオブジェクトから引き離されたMethod
  ・直接callすることは出来ない
  ・元のクラスと同じオブジェクトに束縛すればcallすることが出来る
  ・ModuleからUnboundしたメソッドであれば、どこにでもBind出来る
  EOS

  module MyModule
    def my_method
      42
    end
  end

  puts '引きはがし'
  obj2 = MyClass.new(2)
  m2 = obj2.method :my_method
  ubm2 = m2.unbind
  p ubm2

  puts 'Moduleから直接UnboundMethodを取り出し'
  unbound = MyModule.instance_method(:my_method)
  p unbound   # -> #<UnboundMethod: MyModule#my_method>

  puts 'Moduleから引きはがしたUnboundMethodをStringにbindする'
  String.send :define_method, :another_method, unbound

  puts "abc".another_method


  puts 'MyClassからUnboundしたmy_methodを別のMyClassオブジェクトに束縛する'
  puts '※一応エラーなく動作しているようだが、、、何をやってるんだか良く分からなくなってきた…'
  obj3 = MyClass.new(3)
  m2b = ubm2.bind(obj3)

  p m2b           # -> #<Method: MyClass#my_method>
  puts m2b.call   # -> 3





rescue => e
  p e
end
