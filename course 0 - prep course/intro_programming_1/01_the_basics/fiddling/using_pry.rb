# testing debugging
require 'pry'

x = 12
y = 2 * x

puts "y = #{y}"

# use pry to check and manipulate variables
binding.pry

if y < 10
  puts "Hey, y is really small, it's #{y}"
else
  puts "Wow, your y is really big, it's #{y}"
end
