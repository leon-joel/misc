require 'minitest/autorun'
require_relative 'test-helper'

# テスト対象
require_relative '../version'


require 'uri'

class Monitor
  def initialize(server)
    @server = server
  end

  def alive?
    echo = Time.now.to_f.to_s
    response = get(echo)
    response.success? && response.body == echo
  end

  private
  def get(echo)
    url = URI::HTTP.build(host: @server,
                          path: "/echo/#{echo}")
    HTTP.get(url.to_s)
  end
end


class MonitorTest < Minitest::Test
  def test_successful_monitor
    monitor = Monitor.new("example.com")
    response = Minitest::Mock.new

    # getメソッドを差し替えて、responseをMockで定義したものに差し替える
    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, true)
      response.expect(:body, echo)
      response
    end

    assert(monitor.alive?, "should be alive")

    # 呼び出されていないMockメソッドがあった場合はMockExpectationErrorがthrowされる
    response.verify
  end

  def test_failed_monitor
    monitor = Monitor.new("example.com")
    response = Minitest::Mock.new

    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, false)
      response
    end

    refute(monitor.alive?, "shouldn't be alive")
    response.verify
  end
end

# MockとStub
# http://blog.willnet.in/entry/2012/12/05/004010
# ===================================================================
class Person
  def eat(food)
    food.taste
  end

  def drink(whisky)
    whisky.alcohol.upcase
  end
end

class Whisky
  def alcohol
    # まだ実装されていない
  end
end


# Mock
# ----------------------------------------------------------------
describe Person do
  subject { Person.new }

  describe '#eat' do
    it '引数にとったオブジェクトの #taste を実行していること' do
      food = MiniTest::Mock.new.expect(:taste, 'terrible')
      subject.eat(food).must_equal("terrible")
      food.verify
    end

    it '引数にとったオブジェクトの #smell を実行していないこと' do
      food = MiniTest::Mock.new.expect(:smell, 'good')
      def food.taste; 'terrible' end
      subject.eat(food)
      -> { food.verify }.must_raise(MockExpectationError)
    end
  end
end

# Stub
# ----------------------------------------------------------------
describe Person do
  subject { Person.new }

  describe '#drink' do
    describe '引数に取ったオブジェクトの #alcohol メソッドが "strong!" を返すとき' do
      it 'STRONG!を返すこと' do
        whisky = Whisky.new
        # stub: blockの中だけalcoholメソッドの戻り値を変更する
        whisky.stub(:alcohol, 'strong!') do
          subject.drink(whisky).must_equal 'STRONG!'
        end
      end

      it '引数の#alcohol メソッドを呼んでいること' do
        mock = MiniTest::Mock.new.expect(:call, 'strong!')
        whisky = Whisky.new
        # stub: blockの中だけalcoholメソッドの戻り値を変更する
        whisky.stub(:alcohol, mock) do
          subject.drink(whisky)
        end
        mock.verify
      end
    end
  end
end