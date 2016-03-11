class DS
  def initialize; end
  def get_cpu_info(workstation_id)  "Core i5"  end
  def get_cpu_price(workstation_id) 200 end
  def get_mouse_info(workstation_id) "MS Mouse" end
  def get_mouse_price(workstation_id) 65 end
  def get_keyboard_info(workstation_id) "MS Keyboard" end
  def get_keyboard_price(workstation_id) 23 end
  def get_display_info(workstation_id) "IIYAMA 27" end
  def get_display_price(workstation_id) 330 end

end



class Lawyer; end

nick = Lawyer.new
# nick.talk_simple    # method_missingが呼び出され、NoMethodErrorが発生する

# 明示的に method_missingメソッドを呼び出している。もちろんNoMethodErrorが発生する。
#nick.send :method_missing, :my_method



puts
puts "method_missingをオーバーライド"

class Lawyer2
  def method_missing(method, *args)
    p self
    puts "called: #{method}(#{args.join(', ')})"
    puts "(block given)" if block_given?
  end
end

bob = Lawyer2.new
bob.talk_simple('a', 'b') do
  'ブロック'
end
