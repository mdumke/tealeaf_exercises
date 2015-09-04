# exercise 3: hash-looping
capitals = {
  france:       'Paris',
  ethiopia:     'Addis Ababa',
  sierra_leone: 'Freetown',
  israel:       'Jerusalem'
}

# returns the correctly formatted country name as a string
def country_symbol_to_string country
  country = country
    .to_s
    .split('_')
    .each { |s| s.capitalize! }
    .join(' ')
end

puts "Some countries are #{capitals.keys}."
puts "Some capitals would be #{capitals.values}."

puts "\nSo, to put everything together:"

capitals.each do |country, capital|
  puts "- #{capital} is the capital of #{country_symbol_to_string(country)}."
end

