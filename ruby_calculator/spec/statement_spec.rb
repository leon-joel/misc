require 'rspec'
require_relative "../interp"

describe 'if_statement' do
  let(:env) { {} }

  it 'if_true' do
    tree = minruby_parse <<~EOS
      if 0 == 0
        x = 1
      else
        x = 2
      end
    EOS
    expect(evaluate(tree, env)).to eq 1
    expect(env["x"]).to eq 1
  end

  it 'if_false' do
    tree = minruby_parse <<~EOS
      if 0 < 0
        x = 1
      else
        x = 2
      end
    EOS
    expect(evaluate(tree, env)).to eq 2
    expect(env["x"]).to eq 2
  end

  it 'if_complex_condition' do
    tree = minruby_parse <<~EOS
      if (1 + 2) < (2 ** 2)
        1 * (2 + 3)
      else
        y = (10 - 1) / 3
      end
    EOS
    expect(evaluate(tree, env)).to eq 5
    expect(env.has_key?("y")).to be_falsey

    tree = minruby_parse <<~EOS
      x = 1      
      if (1 + 2) >= (2 ** 2)
        x = x + 1
        y = 1 * (x + 3)
      else
        x = x * 4
        y = (10 - x) / 3
      end
    EOS
    expect(evaluate(tree, env)).to eq 2
    expect(env["x"]).to eq 4
    expect(env["y"]).to eq 2
  end
end

describe 'while_statement' do
  let(:env) { {} }

  it 'while_loop' do
    src = <<~EOS
      i = 0
      while i < 10
        p(i)
        i = i + 1
      end
    EOS
    tree = minruby_parse(src)
    expect(evaluate(tree, env)).to be_nil
    expect(env["i"]).to eq 10
  end
end
