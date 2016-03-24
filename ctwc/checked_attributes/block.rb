require 'test/unit'

class Person; end

class TestCheckedAttribute < Test::Unit::TestCase
  def setup
    add_checked_attribute(Person, :age) { |v| 18 <= v }
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

  # def test_refuses_nil_values
  #   assert_raises RuntimeError, 'Invalid attribute' do
  #     @bob.age = false
  #   end
  # end
  #
  # def test_refuses_false_values
  #   assert_raises RuntimeError, 'Invalid attribute' do
  #     @bob.age = false
  #   end
  # end

end

def add_checked_attribute(klass, attribute, &validation)
  ###                            ###
  ### 検証用のBlockを渡せるように ###
  ###                            ###
  klass.class_eval do
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





