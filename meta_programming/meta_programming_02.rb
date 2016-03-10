
puts "== トップレベルのself ==================="
p self          # -> main
p self.class    # -> Object
puts

class Rabbit
  puts "== Rabbitクラス定義内でのself ==================="
  p self        # -> Rabbit
  p self.class  # -> Class
                #    ※Ruby では、クラスもオブジェクトの一つで Classクラスの インスタンスです
                #      http://docs.ruby-lang.org/ja/2.2.0/doc/spec=2fdef.html
  puts

  def jump
    puts "== Rabbitクラスメソッド内でのself ==================="
    p self        # -> #<Rabiit:xxxxxx>
    p self.class  # -> Rabbit ※つまり、Rabbitクラスのオブジェクトだということ
    puts "pyon pyon"
    puts
  end
end

Rabbit.new.jump