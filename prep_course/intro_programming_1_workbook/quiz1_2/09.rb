# Using array#map!, shorten each of these names to just 3 characters
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

p flintstones.map! { |name| name[0, 3] }
