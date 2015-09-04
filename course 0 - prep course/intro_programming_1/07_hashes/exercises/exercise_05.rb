# exercise 5: checking hash-content
animals = {
  friendly: 'turtle',
  nasty:    'mosquito'
}

puts "Did you know that the tutle is an animal?"

if animals.has_value? 'turtle'
  puts "- Yes, of course! I invented it!"
else
  puts "- No, but I don't care anyways..."
end
