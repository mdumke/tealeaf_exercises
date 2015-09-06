require_relative '01_roman_numerals'

# super simple testsuite with cases from the live session
arab = [1, 2, 3, 4, 5, 6, 27, 48, 59,
        93, 141, 163, 402, 575, 911, 1024, 1981, 3000]

roman = %w(I II III IV V VI XXVII XLVIII LIX CXIII CXLI CLXIII
           CDII DLXXV CMXI MXXIV MCMLXXXI MMM)

any_errors = false

# compare numbers and put an error message if a pair doesn't match
arab.zip(roman).each do |a, r|
  if a.to_roman != r
    puts "#{a}: expected #{r}, got #{a.to_roman}"
    any_errors = true
  end
end

puts 'all tests pass' unless any_errors
