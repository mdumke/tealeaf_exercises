# Create a hash that expresses the frequency with which each letter occurs in this string:

statement = "The Flintstones Rock"
# ex:

# { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }

# the counting operation is potentially slow, so optimize this (here: O(1)!)
frequencies = Array.new(128, 0)
statement.each_byte { |char| frequencies[char] += 1 }

# transform the counts into the requested format
letter_count = (('A'..'Z').to_a.zip(frequencies.slice('A'.ord..'Z'.ord)) +
                ('a'..'z').to_a.zip(frequencies.slice('a'.ord..'z'.ord)))

p letter_count.reject { |char, count| count == 0 }.to_h
