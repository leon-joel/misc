def add(x, y)
  x + y
end

def fizzbuzz(limit)
  i = 1
  while i <= limit
    if i % 3 == 0
      if i % 5 == 0
        p("FizzBuzz")
      else
        p("Fizz")
      end
    else
      if i % 5 == 0
        p("Buzz")
      else
        p(i)
      end
    end
    i = i + 1
  end
end