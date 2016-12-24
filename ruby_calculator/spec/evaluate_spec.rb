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

  it 'compare evaluation (equel)' do
    expect(evaluate(minruby_parse("1 == 1"))).to be_truthy
    expect(evaluate(minruby_parse("1 == 0"))).to be_falsey

    expect(evaluate(minruby_parse("2 * 3 == 6"))).to be_truthy
    expect(evaluate(minruby_parse("6 == 2 * 3"))).to be_truthy

    expect(evaluate(minruby_parse("12 / 3 == 6"))).to be_falsey
    expect(evaluate(minruby_parse("6 == 12 / 3"))).to be_falsey

    expect(evaluate(minruby_parse("12 / 3 == 2 ** 2"))).to be_truthy
    expect(evaluate(minruby_parse("(6 % 4) * 6 == 12 * 5 / (3 + 2)"))).to be_truthy

    expect(evaluate(minruby_parse("12 / 3 == (3 % 2) ** 4"))).to be_falsey
    expect(evaluate(minruby_parse("6 ** 2 == 12 ** 3"))).to be_falsey
  end

  it 'compare evaluation (lt, le, gt, ge)' do
    expect(evaluate(minruby_parse("0 < 1"))).to be_truthy
    expect(evaluate(minruby_parse("0 < 0"))).to be_falsey
    expect(evaluate(minruby_parse("0 <= 0"))).to be_truthy
    expect(evaluate(minruby_parse("1 <= 0"))).to be_falsey

    expect(evaluate(minruby_parse("2 > 1"))).to be_truthy
    expect(evaluate(minruby_parse("2 > 2"))).to be_falsey
    expect(evaluate(minruby_parse("2 >= 2"))).to be_truthy
    expect(evaluate(minruby_parse("1 >= 2"))).to be_falsey

    expect(evaluate(minruby_parse("0 < (2 + 3 * 4 - 10) / 4"))).to be_truthy
    expect(evaluate(minruby_parse("1 < (2 + 3 * 4 - 10) / 4"))).to be_falsey
    expect(evaluate(minruby_parse("0 >= (2 + 3 * 4 - 10) / 4"))).to be_falsey
    expect(evaluate(minruby_parse("1 >= (2 + 3 * 4 - 10) / 4"))).to be_truthy

    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 < 5 % 3"))).to be_truthy
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 < 5 % 3 - 1"))).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 >= 5 % 3"))).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 >= 5 % 3 - 1"))).to be_truthy

    expect(evaluate(minruby_parse("1 <= (2 + 3 * 4 - 10) / 4"))).to be_truthy
    expect(evaluate(minruby_parse("2 <= (2 + 3 * 4 - 10) / 4"))).to be_falsey
    expect(evaluate(minruby_parse("1 > (2 + 3 * 4 - 10) / 4"))).to be_falsey
    expect(evaluate(minruby_parse("2 > (2 + 3 * 4 - 10) / 4"))).to be_truthy

    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 <= 1 ** 1"))).to be_truthy
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 <= 1 % 1"))).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 > 1 ** 1"))).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 > 1 % 1"))).to be_truthy
  end



  it 'complex evaluation' do

    tree = minruby_parse("(1 + 2) + (3 + 4)")
    expect(evaluate(tree)).to eq 10

    tree = minruby_parse("(1 * 2) * (3 + 4)")
    expect(evaluate(tree)).to eq 14

    tree = minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")
    expect(evaluate(tree)).to eq 100
  end

  it 'max evaluation' do
    expect(max(minruby_parse("1 + 2"))).to eq 2
    expect(max(minruby_parse("1 + 2 * 3"))).to eq 3
    expect(max(minruby_parse("1 + 4 + 3"))).to eq 4
    expect(max(minruby_parse("3 - (1 * 2)"))).to eq 3
    expect(max(minruby_parse("(1 ** 2) + (3 / 4) ^ 5"))).to eq 5
  end

end