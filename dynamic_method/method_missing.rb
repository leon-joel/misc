class DS
  def initialize; end
  def get_cpu_info(workstation_id)  "Core i5"  end
  def get_cpu_price(workstation_id) 200 end
  def get_mouse_info(workstation_id) "MS Mouse" end
  def get_mouse_price(workstation_id) 65 end
  def get_keyboard_info(workstation_id) "MS Keyboard" end
  def get_keyboard_price(workstation_id) 23 end
  def get_monitor_info(workstation_id) "IIYAMA 27" end  # displayという名前は既存メソッドとかぶってしまう
  def get_monitor_price(workstation_id) 330 end         # :


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


puts
puts 'method_missingを使ったリファクタリング'

class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def method_missing(name)
    super if !@data_source.respond_to?("get_#{name}_info")
    info = @data_source.send("get_#{name}_info", @id)
    price = @data_source.send("get_#{name}_price", @id)
    result = "#{name.capitalize}: #{info} ($#{price})"
    return "* #{result}" if 100 <= price
    result
  end

  # respond_to? が正しく反応するよう、respond_to_missing? をオーバーライドしておく。
  def respond_to_missing?(method, include_private = false)
    @data_source.respond_to?("get_#{method}_info") || super
  end
end

my_computer = Computer.new(42, DS.new)
# respond_to?を正しく実装することで、存在する場合のみ呼び出すというようにすることも可能
# puts my_computer.cpu if my_computer.respond_to?(:cpu)

puts my_computer.cpu

puts my_computer.mouse
puts my_computer.keyboard
puts my_computer.monitor
# puts my_computer.memory   # このメソッドは存在しない
puts my_computer.display  # このメソッドは存在するが、Objectクラスの全く別のメソッド




puts
puts <<-'EOS'
method_missingを使ったリファクタリング2 【ブランクスレート Blank Slate】
  様々なメソッドが実装されているObjectクラスを継承すると、それらのメソッドが邪魔になることがある。
  そこでBlank Slate＝BasciObject を継承することで様々な面倒から解放される。
EOS


class Computer2 < BasicObject
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def method_missing(name)
    super if !@data_source.respond_to?("get_#{name}_info")
    info = @data_source.send("get_#{name}_info", @id)
    price = @data_source.send("get_#{name}_price", @id)
    result = "#{name.capitalize}: #{info} ($#{price})"
    return "* #{result}" if 100 <= price
    result
  end

  # BasicObjectは respond_to? メソッドを持たないので、
  # respond_to_missing? も不要となる。
end

my_computer = Computer2.new(42, DS.new)
# respond_to?を正しく実装することで、存在する場合のみ呼び出すというようにすることも可能
# puts my_computer.cpu if my_computer.respond_to?(:cpu)

puts my_computer.cpu

puts my_computer.mouse
puts my_computer.keyboard
puts my_computer.monitor
# puts my_computer.memory   # このメソッドは存在しない
# puts my_computer.display  # Blank Slateにしたので、このメソッドも存在しなくなった。



