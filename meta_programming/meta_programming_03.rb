
### http://www.atmarkit.co.jp/ait/articles/1501/06/news028.html


class Rabbit
  def initialize
    @roar = "boo"
  end

  def _speak
    puts @roar
  end

  def speak
    p self
    p self.class

    # 以下はどちらも同じ結果となる
    # _speak
    self._speak   # 明示的にレシーバー（メソッドを呼び出す対象のオブジェクト）を指定
  end
end

Rabbit.new.speak