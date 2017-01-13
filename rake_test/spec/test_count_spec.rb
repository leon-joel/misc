require 'rspec'
require_relative '../count_char'

describe 'count_char' do
  it { expect(count_char("abacac")).to eq [["a", 3], ["b", 1], ["c", 2]] }
end