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
class Computer

  # def initialize(computer_id, data_source)
  #   @id = computer_id
  #   @data_source = data_source
  # end

  # ■素朴に記述 コピペの山
  # def mouse
  #   info = @data_source.get_mouse_info(@id)
  #   price = @data_source.get_mouse_price(@id)
  #   result = "Mouse: #{info} ($#{price})"
  #   return "* #{result}" if 100 <= price
  #   result
  # end
  #
  # def cpu
  #   info = @data_source.get_cpu_info(@id)
  #   price = @data_source.get_cpu_price(@id)
  #   result = "Cpu: #{info} ($#{price})"
  #   return "* #{result}" if 100 <= price
  #   result
  # end
  #
  # def keyboard
  #   info = @data_source.get_keyboard_info(@id)
  #   price = @data_source.get_keyboard_price(@id)
  #   result = "Keyboard: #{info} ($#{price})"
  #   return "* #{result}" if 100 <= price
  #   result
  # end

  # ■componentメソッドに共通化 【動的ディスパッチ】※sendメソッド使用
  # def mouse
  #   component :mouse
  # end
  # def cpu
  #   component :cpu
  # end
  # def keyboard
  #   component :keyboard
  # end
  #
  # def component(name)
  #   info = @data_source.send "get_#{name}_info", @id
  #   price = @data_source.send "get_#{name}_price", @id
  #   result = "#{name.capitalize}: #{info} ($#{price})"
  #   return "* #{result}" if 100 <= price
  #   result
  # end

  # ■mouse, cpu...などのメソッドを define_methodを使ってあらかじめ作成しておく【動的メソッド】
  # # メソッドを生成するクラスメソッド
  def self.define_component(name)
    define_method(name) do
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if 100 <= price
      result
    end
  end

  # puts 'メソッド生成前'
  # p self.instance_methods(false)
  #
  #
  # # 各コンポーネントに対応するメソッドを生成
  # define_component :mouse
  # define_component :cpu
  # define_component :keyboard
  #
  # puts 'メソッド生成後'
  # p self.instance_methods(false)

  # ■data_sourceに実装されているget_xxx_infoメソッドを列挙し、それぞれに対応するメソッドを生成する
  #   これにより、このクラスからmouseやらcpuなどの文字が完全に消えた。
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    p data_source.methods.grep(/^get_(.*)_info$/) { Computer.define_component $1 }
    # -> [:cpu, :mouse, :keyboard]
  end

end

ds = DS.new

c = Computer.new(1, ds)
puts
puts c.mouse
puts c.cpu
puts c.keyboard