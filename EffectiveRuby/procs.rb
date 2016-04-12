#require 'pp'
require 'logger'
require 'active_support/core_ext/string/strip'

def pass(&block) block; end


p g = pass { |name| "Hello #{name}"}    # -> #<Proc:0x2af9e28@C.....>
