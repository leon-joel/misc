require 'fuzzbert'
require 'uri'

fuzz('URI::HTTP::build') do
  data("random server names") do
    FuzzBert::Generators.random
  end

  deploy do |data|
    URI::HTTP::build(host: data, path: '/')
  end
end