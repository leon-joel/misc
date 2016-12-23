require 'rspec'
require_relative "../evaluate"

describe 'My behaviour' do

  it 'simple evaluation' do
    tree = minruby_parse("7 % 3")
    expect(evaluate(tree)).to eq 1
    tree = minruby_parse("7 % 7")
    expect(evaluate(tree)).to eq 0

    tree = minruby_parse("2 ** 3")
    expect(evaluate(tree)).to eq 8
    tree = minruby_parse("1 ** 3")
    expect(evaluate(tree)).to eq 1
    tree = minruby_parse("0 ** 3")
    expect(evaluate(tree)).to eq 0
    tree = minruby_parse("2 ** 0")
    expect(evaluate(tree)).to eq 1
  end

  it 'should do something' do

    tree = minruby_parse("(1 + 2) + (3 + 4)")
    expect(evaluate(tree)).to eq 10

    tree = minruby_parse("(1 * 2) * (3 + 4)")
    expect(evaluate(tree)).to eq 14

    tree = minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")
    expect(evaluate(tree)).to eq 100
  end
end