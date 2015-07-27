# How can we add the family pet "Dino" to our usual array
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

p flintstones << 'Dino'
p flintstones.push('Dino')
p flintstones.unshift('Dino')
p flintstones.insert(2, 'Dino')
p flintstones.concat(['Dino'])
p flintstones + ['Dino']
# set operation will reduce the set to unique items
p flintstones | ['Dino']
