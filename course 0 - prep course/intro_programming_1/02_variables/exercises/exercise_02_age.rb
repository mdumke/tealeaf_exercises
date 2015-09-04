# exercise 2: getting and calculating age
print "Hey, you look amazing! How old are you, by the way? "
age = gets.chomp.to_i

puts ""

for number in [10, 20, 30, 40] do
  puts "In #{number} years you will be #{age + number} (if you survive until then)."
end
