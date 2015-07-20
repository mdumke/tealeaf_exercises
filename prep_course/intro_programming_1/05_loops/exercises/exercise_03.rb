# coding: utf-8

# exercise 3: each_with_index
some_array = ['Bohnen', 'Farben', 'Bauernhof', 'Taschentuch', 'Nasenhaare']

some_array.each_with_index do |item, index|
  p "#{index + 1}. #{item}"
end
