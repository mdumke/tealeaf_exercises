flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# question 10: Turn this array into a hash where the names are the keys and the values are the positions in the array.

p flintstones.map.with_index {|name, idx| [name, idx]}.to_h

