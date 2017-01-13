# *_test.rb というファイル名は rake test の対象外になるようだ（＝見つけてくれない）

require 'test/unit'
require_relative '../count_char'

class TestCountChar < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_count_char2
    assert_equal(2, 3)
  end
end