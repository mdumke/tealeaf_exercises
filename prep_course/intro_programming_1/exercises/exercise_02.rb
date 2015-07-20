# coding: utf-8

# exercise 2: merge vs merge!
hash1 = {a: 1}
hash2 = {b: 2}

puts "In the beginning, hash1 is #{hash1} and hash2 is #{hash2}."
puts "Now when we use merge, the return value is #{hash1.merge hash2}, but hash1 is still #{hash1} and hash2 is still #{hash2}."

puts "\nBut now for the real shit. We merge! hash2 into hash1 and get #{hash1.merge! hash2} as return value. But now hash1 is #{hash1}. Oho! hash2, on the other hand, was not effected, it is still #{hash2}."

puts "\nOk, if those sentences make sense at runtime, I think I got the concept..."

