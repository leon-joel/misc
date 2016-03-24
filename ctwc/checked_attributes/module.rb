require 'test/unit'

###
### Moduleをincludeすると、クラスマクロ（attr_checkedクラスメソッド）がextendされるように改良
###
module CheckedAttributes
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_checked(attribute, &validation)
      define_method "#{attribute}=" do |value|
        raise 'Invalid attribute' unless validation.call(value)
        # インスタンス変数への代入
        instance_variable_set("@#{attribute}", value)
      end

      define_method attribute do
        # インスタンス変数値の取得
        instance_variable_get("@#{attribute}")
      end
    end
  end
end


class Person
  include CheckedAttributes

  attr_checked :age do |v|
    18 <= v
  end
end


class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_invalid_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = 17
    end
  end
end

