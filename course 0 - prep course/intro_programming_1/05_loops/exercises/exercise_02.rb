# exercise 2: breaking loops
loop do
  puts "\nHi, your lucky number is now #{rand(1..100)}"
  puts "Would you like to change it? (Y/n)"

  response = gets.chomp.downcase

  break unless response == 'y'
end
