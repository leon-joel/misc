require 'rspec'
require_relative "../interp"

describe 'if_statement' do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'if_true' do
    tree = minruby_parse <<~EOS
      if 0 == 0
        x = 1
      else
        x = 2
      end
    EOS
    expect(evaluate(tree, genv, lenv)).to eq 1
    expect(lenv["x"]).to eq 1
  end

  it 'if_false' do
    tree = minruby_parse <<~EOS
      if 0 < 0
        x = 1
      else
        x = 2
      end
    EOS
    expect(evaluate(tree, genv, lenv)).to eq 2
    expect(lenv["x"]).to eq 2
  end

  it 'if_complex_condition' do
    tree = minruby_parse <<~EOS
      if (1 + 2) < (2 ** 2)
        1 * (2 + 3)
      else
        y = (10 - 1) / 3
      end
    EOS
    expect(evaluate(tree, genv, lenv)).to eq 5
    expect(lenv.has_key?("y")).to be_falsey

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
    expect(evaluate(tree, genv, lenv)).to eq 2
    expect(lenv["x"]).to eq 4
    expect(lenv["y"]).to eq 2
  end
end

describe 'while_statement' do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'while_loop' do
    src = <<~EOS
      i = 0
      while i < 10
        p(i)
        i = i + 1
      end
    EOS
    tree = minruby_parse(src)
    expect(evaluate(tree, genv, lenv)).to be_nil  # 戻り値はnil
    expect(lenv["i"]).to eq 10
  end

  it 'never_loop' do
    src = <<~EOS
      i = 100
      while i < 10
        p(i)
        i = i + 1
      end
    EOS
    tree = minruby_parse(src)
    expect(evaluate(tree, genv, lenv)).to be_nil   # 戻り値はnil
    expect(lenv["i"]).to eq 100
  end

end

describe "begin_end_while_statement" do
  let(:genv) { prepare_genv }
  let(:lenv) { {} }

  it 'while2_loop' do
    src = <<~EOS
      i = 0
      begin
        p(i)
        i = i + 1
      end while i < 10
    EOS
    tree = minruby_parse(src)
    expect(evaluate(tree, genv, lenv)).to be_nil   # 戻り値はnil
    expect(lenv["i"]).to eq 10
  end

  it 'once_loop' do
    src = <<~EOS
      i = 100
      begin
        p(i)
        i = i + 1
      end while i < 10
    EOS
    tree = minruby_parse(src)
    expect(evaluate(tree, genv, lenv)).to be_nil   # 戻り値はnil
    expect(lenv["i"]).to eq 101
  end
end
