require 'test/unit'

class Person; end

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    add_checked_attribute(Person, :age)
    @bob = Person.new
  end

  def test_accepts_valid_values
    @bob.age = 20
    assert_equal 20, @bob.age
  end

  def test_refuses_nil_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = false
    end
  end

  def test_refuses_false_values
    assert_raises RuntimeError, 'Invalid attribute' do
      @bob.age = false
    end
  end

end

def add_checked_attribute(klass, attribute)
  ###                                       ###
  ### eval を廃止して、class_eval に置き換え ###
  ###                                       ###
  klass.class_eval do
    define_method "#{attribute}=" do |value|
      raise 'Invalid attribute' unless value
      # インスタンス変数への代入
      instance_variable_set("@#{attribute}", value)
    end

    define_method attribute do
      # インスタンス変数値の取得
      instance_variable_get("@#{attribute}")
    end
  end
end





