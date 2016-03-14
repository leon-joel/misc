puts <<-'EOS'
デバッグがむずかしく危険なmethod_missing！
必要がないならmethod_missiogは使わない方が良い！
EOS

class Roulette
  def method_missing(name, *args)
    person = name.to_s.capitalize
    super unless %w[Bob Frank Bill].include? person   # ガードがないと危険
    number = 0  # これを入れておかないと、結果表示のところで number【メソッド】を呼び出そうとして、method_missingとなり、
                # 無限再帰に入ってしまう！
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end
    "#{person} got a #{number}"
  end
end

number_of = Roulette.new
puts number_of.bob
puts number_of.frank
# puts number_of.tak    # 見つからない