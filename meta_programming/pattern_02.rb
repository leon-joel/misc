### 動的にクラスとメソッドを定義している
###   http://www.atmarkit.co.jp/ait/articles/1501/06/news028.html

{Cat: "meow", Dog: "woof", Owl: "hoot-hoot", Rabbit: "boo"}.each do |animal, roar|
  # クラスの動的定義
  Object.const_set animal, Class.new

  # speakというメソッドを動的に定義
  Object.const_get(animal).class_eval do
    define_method :speak do |count|
      count.times { puts roar }
    end
  end
end

Cat.new.speak(2)
Dog.new.speak(2)
Owl.new.speak(2)
Rabbit.new.speak(2)