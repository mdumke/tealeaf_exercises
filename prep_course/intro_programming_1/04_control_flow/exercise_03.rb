# coding: utf-8

# exercise 3: checking a number

print "Hey, why don't you input an interger here: "
int = gets.chomp.to_i

case
when int > 100
  puts "Wow, pretty big number, dawg!"
when int > 50
  puts "That's a nice number. I like that."
when int > 0
  puts "It's a bit small, but still OK."
else
  puts "This is unacceptable. You can't do this to me."
end

