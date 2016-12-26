require 'rspec'
require_relative "../interp"

describe 'My behaviour' do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }
  it 'simple evaluation' do
    tree = minruby_parse("7 % 3")
    expect(evaluate(tree, genv, lenv)).to eq 1
    tree = minruby_parse("7 % 7")
    expect(evaluate(tree, genv, lenv)).to eq 0

    tree = minruby_parse("2 ** 3")
    expect(evaluate(tree, genv, lenv)).to eq 8
    tree = minruby_parse("1 ** 3")
    expect(evaluate(tree, genv, lenv)).to eq 1
    tree = minruby_parse("0 ** 3")
    expect(evaluate(tree, genv, lenv)).to eq 0
    tree = minruby_parse("2 ** 0")
    expect(evaluate(tree, genv, lenv)).to eq 1
  end

  it 'compare evaluation (equel)' do
    expect(evaluate(minruby_parse("1 == 1"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("1 == 0"), genv, lenv)).to be_falsey

    expect(evaluate(minruby_parse("2 * 3 == 6"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("6 == 2 * 3"), genv, lenv)).to be_truthy

    expect(evaluate(minruby_parse("12 / 3 == 6"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("6 == 12 / 3"), genv, lenv)).to be_falsey

    expect(evaluate(minruby_parse("12 / 3 == 2 ** 2"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("(6 % 4) * 6 == 12 * 5 / (3 + 2)"), genv, lenv)).to be_truthy

    expect(evaluate(minruby_parse("12 / 3 == (3 % 2) ** 4"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("6 ** 2 == 12 ** 3"), genv, lenv)).to be_falsey
  end

  it 'compare evaluation (lt, le, gt, ge)' do
    expect(evaluate(minruby_parse("0 < 1"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("0 < 0"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("0 <= 0"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("1 <= 0"), genv, lenv)).to be_falsey

    expect(evaluate(minruby_parse("2 > 1"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("2 > 2"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("2 >= 2"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("1 >= 2"), genv, lenv)).to be_falsey

    expect(evaluate(minruby_parse("0 < (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("1 < (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("0 >= (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("1 >= (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_truthy

    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 < 5 % 3"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 < 5 % 3 - 1"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 >= 5 % 3"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 >= 5 % 3 - 1"), genv, lenv)).to be_truthy

    expect(evaluate(minruby_parse("1 <= (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("2 <= (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("1 > (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("2 > (2 + 3 * 4 - 10) / 4"), genv, lenv)).to be_truthy

    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 <= 1 ** 1"), genv, lenv)).to be_truthy
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 <= 1 % 1"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 > 1 ** 1"), genv, lenv)).to be_falsey
    expect(evaluate(minruby_parse("(2 + 3 * 4 - 10) / 4 > 1 % 1"), genv, lenv)).to be_truthy
  end



  it 'complex evaluation' do

    tree = minruby_parse("(1 + 2) + (3 + 4)")
    expect(evaluate(tree, genv, lenv)).to eq 10

    tree = minruby_parse("(1 * 2) * (3 + 4)")
    expect(evaluate(tree, genv, lenv)).to eq 14

    tree = minruby_parse("(1 + 2) / 3 * 4 * (56 / 7 + 8 + 9)")
    expect(evaluate(tree, genv, lenv)).to eq 100
  end

  it 'max evaluation' do
    expect(max(minruby_parse("1 + 2"))).to eq 2
    expect(max(minruby_parse("1 + 2 * 3"))).to eq 3
    expect(max(minruby_parse("1 + 4 + 3"))).to eq 4
    expect(max(minruby_parse("3 - (1 * 2)"))).to eq 3
    expect(max(minruby_parse("(1 ** 2) + (3 / 4) ^ 5"))).to eq 5
  end
end

# 第5回 練習問題2 ※http://ascii.jp/elem/000/001/264/1264148/
describe "profiler" do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'plus_count not found' do
    tree = minruby_parse("1 + 2")
    expect(evaluate(tree, genv, lenv)).to eq 3
    expect(lenv["plus_count"]).to be_nil
  end

  it 'plus_count found' do
    tree = minruby_parse <<~EOS
      plus_count = 0
      x = 1 + 2
    EOS
    expect(evaluate(tree, genv, lenv)).to eq 3
    expect(lenv["plus_count"]).to eq 1
    expect(lenv["x"]).to eq 3

    # 同じ環境（lenv）を使って別の演算もやらせる
    tree = minruby_parse("x = x + 1")
    expect(evaluate(tree, genv, lenv)).to eq 4
    expect(lenv["plus_count"]).to eq 2
    expect(lenv["x"]).to eq 4
  end
end

describe "invalid case" do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'invalid operator' do
    tree = minruby_parse("x = x && 1")
    expect {evaluate(tree, genv, lenv)}.to raise_error("unknown_operator")
  end
end