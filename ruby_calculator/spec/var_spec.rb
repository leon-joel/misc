require 'rspec'
require_relative "../interp"

describe 'var assign' do
  let(:env) { {} }

  it 'lit assign' do
    tree = minruby_parse("x = 3")
    # p tree
    evaluate(tree, env)
    ans = { "x" => 3 }
    expect(env).to eq ans
  end

  it 'operator assign' do
    evaluate(minruby_parse("result = 1 * (2 + 4) / 2 - 2"), env)
    ans = { "result" => 1 }
    expect(env).to eq ans
  end
end