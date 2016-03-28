require 'active_support'
require 'active_record'


module MyConcern
  extend ActiveSupport::Concern

  def an_instance_method; "インスタンスメソッド"; end

  module ClassMethods
    def a_class_method; "クラスメソッド"; end
  end
end

class MyClass
  include MyConcern
end

puts MyClass.new.an_instance_method

puts MyClass.a_class_method


p MyClass.ancestors

p ActiveRecord::Base.class.ancestors
