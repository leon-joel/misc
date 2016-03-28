module SecondLevelModule
  def self.included(base)
    # includeされると、ClassMethodsのメソッドがextend（つまり、クラスメソッドとしてbaseクラスに追加）されるようにしている
    base.extend ClassMethods
  end

  def second_level_instance_method; 'ok'; end

  module ClassMethods
    def second_level_class_method; 'ok'; end
  end
end

module FirstLevelModule
  def self.included(base)
    base.extend ClassMethods
  end

  def first_level_instance_method; 'ok'; end

  module ClassMethods
    def first_level_class_method; 'ok'; end
  end

  # ここで入れ子のinclude。これが問題。
  # SecondLevelのクラスメソッドがFirstLevelのクラスメソッドとしてextendされてしまう！
  include SecondLevelModule
end

class BaseClass
  include FirstLevelModule
end

p BaseClass.ancestors

puts BaseClass.new.first_level_instance_method
puts BaseClass.new.second_level_instance_method

puts BaseClass.first_level_class_method
# puts BaseClass.second_level_class_method    # NoMethodError



