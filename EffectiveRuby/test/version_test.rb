require 'minitest/autorun'
require_relative 'test-helper'

# テスト対象
require_relative '../version'

# テストクラス
class VersionTest < Minitest::Test

  def setup
    @v1  = Version.new('2.1.1')
    @v1e = Version.new('2.1.1')
    @v2  = Version.new('2.3.1')
  end

  def test_initialize
    v = Version.new('2.1.3')
    assert_equal(v.major, 2, "major")
    assert_equal(v.minor, 1, "minor")
    assert_equal(v.patch, 3, "patch")
  end

  def test_version_compare
    assert_equal(@v1, @v1e)
    refute_equal(@v1, @v2)
    assert_operator(@v1, :<, @v2)
  end
end


describe "Version" do
  describe "when parsing" do
    before do
      @version = Version.new("10.8.9")
    end

    it 'should creates 3 integers' do
      @version.major.must_equal 10
      @version.minor.must_equal 8
      @version.patch.must_equal 9
    end
  end

  describe "when comparing" do
    before do
      @v1  = Version.new('2.1.1')
      @v2  = Version.new('2.3.0')
    end

    it 'orders comparing' do
      @v1.wont_equal @v2
      @v1.must_be(:<, @v2)
    end
  end
end