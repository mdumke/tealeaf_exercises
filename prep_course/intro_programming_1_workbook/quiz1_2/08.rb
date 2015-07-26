# Find the index of the first name that starts with "Be"
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

p flintstones.index { |name| name.match(/^Be/) }
p flintstones.find_index { |name| name.match(/^Be/) }
