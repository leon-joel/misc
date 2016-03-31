require 'active_support/core_ext/string/strip'


module MyRef
  refine NilClass do
    # このようにダミーのメソッドを直接追加してもいいが…
    # def flash; puts "nil flash"; end
    # def ring;  puts "nil ring";  end

    # method_missingで面倒を見ることにしよう
    # ※ 引数の * は引数を無視するという意味
    # def method_missing(*)
    def method_missing(name, *args)
      if name =~ /^(ring|flash)$/
        puts "nil mm #{name}"
      else
        # 知らないメソッドが勝手に追加されていた場合、superを呼び出すことにする
        # ★握りつぶす？エラーにする？ログに出す？など、柔軟に実装できるのがこの方法のメリットでもある。
        #   とはいえ、NilClassのようなグローバルなクラスにメスを入れるのは、分かりにくいトラブルの元になるだけな気がする…
        #   余程のメリットがない限り採用すべきではない手法だと感じる。
        #   但し、Refinementを上手く使って範囲を限定できるのであれば、こういう手法も悪くないかも。

        # ⇒Refinementで限定してみた。
        #   using をMainの直前に置いてみても効果無し。
        #   Alarmクラスの上に置けばOKのようだ。
        super
      end
    end
  end
end



class NullDevice
  def flash; end
  def ring; end
end

class Device
  def flash
    puts "flashed"
  end

  def ring
    puts "rang"
  end
end

class User
  def initialize
    # @dev = Device.new
    @dev = nil
  end

  def device
    @dev
  end
end

class CONFIGURATION

  def self.current_user
    User.new
  end
end


#nil.ring     # ここではNoMethodErrorが出る

using MyRef   # refineを適用

# nil.ring    # ここだとちゃんとringする


class Alarm
  def device
    # nilガードでNullDeviceを返すようにすることで、
    # 「デバイスなし」の場合でもNoMethodErrorが発生しないようにする
    # ⇒でももっとRubyらしくNilClassに手を入れよう
    # CONFIGURATION.current_user.device || NullDevice.new

    CONFIGURATION.current_user.device
  end

  def send_default
    # ガード節入れてもいいけど…
    # return unless device
    3.times { device.ring }
  end

  def send_discreet
    device.ring
  end

  def send_silent
    5.times { device.flash }
  end

  def send_stop_ring
    device.stop_ring
  end
end


# ここじゃダメ
# using MyRef


a = Alarm.new
a.send_default

# 知らないメソッドが新たに追加された場合
# a.send_stop_ring