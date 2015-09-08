# require_relative '2014_11_15_roman_numerals'
require_relative '2014_11_22_roman_numerals_refactored'

# super simple testsuite with cases from the live session
arab = [1, 2, 3, 4, 5, 6, 27, 48, 59,
        93, 141, 163, 402, 575, 644, 911, 1024, 1981, 3000]

roman = %w(I II III IV V VI XXVII XLVIII LIX XCIII CXLI CLXIII
           CDII DLXXV DCXLIV CMXI MXXIV MCMLXXXI MMM)

any_errors = false

# compare numbers and numerals and show an error message if a pair doesn't match
arab.zip(roman).each do |a, r|
  if a.to_roman != r
    puts "#{a}: expected #{r}, got #{a.to_roman}"
    any_errors = true
  end
end

puts 'all tests pass' unless any_errors
