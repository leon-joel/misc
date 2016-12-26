require 'rspec'
require_relative "../interp"

describe 'var_assign and var_ref' do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'lit assign' do
    tree = minruby_parse("x = 3")
    # p tree
    evaluate(tree, genv, lenv)
    ans = { "x" => 3 }
    expect(lenv).to eq ans
  end

  it 'operator assign' do
    evaluate(minruby_parse("result = 1 * (2 + 4) / 2 - 2"), genv, lenv)
    ans = { "result" => 1 }
    expect(lenv).to eq ans
  end

  it 'var ref' do
    tree = minruby_parse <<~EOS
      x = 1
      y = x + 2
    EOS
    evaluate(tree, genv, lenv)
    ans = { "x" => 1, "y" => 3 }
    expect(lenv).to eq ans

  end
end