require 'rspec'
require_relative "../evaluate"

describe 'My behaviour' do

  it 'should do something' do

    tree = minruby_parse("(1 + 2) + (3 + 4)")
    expect(evaluate(tree)).to eq 10

    tree = minruby_parse("(1 * 2) * (3 + 4)")
    expect(evaluate(tree)).to eq 14

    tree = minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")
    expect(evaluate(tree)).to eq 100
  end
end