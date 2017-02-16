
if ARGV.size <= 0
  puts "No argument."
  exit 1
end


sentence = ARGV.shift.encode("UTF-8")
puts sentence



puts sentence.scan(/\b\S+\b/u)


exit 0
