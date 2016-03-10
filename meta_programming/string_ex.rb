module StringEx
  refine String do
    def string_ex
      self + ' extension'
    end
  end
end

using StringEx

p 'string'.string_ex # => "string extension"