# spec_*.rb というファイル名は rake spec の対象外になるようだ（＝見つけてくれない）

require 'rspec'
require_relative '../count_char'

describe 'count_char' do
  it { expect(2).to eq 3 }
end