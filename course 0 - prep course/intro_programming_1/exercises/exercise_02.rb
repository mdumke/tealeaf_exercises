# Same as above (exercise_01), but only print out values greater than 5
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

numbers
  .select { |n| n > 5 }
  .each   { |n| puts n }
