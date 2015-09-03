# exercise 2: upcasing-method

def upcase_long_string str
  return str.upcase if str.length > 10
  str
end

puts upcase_long_string 'Heiner'
puts upcase_long_string 'Heiner ist Keiner'
