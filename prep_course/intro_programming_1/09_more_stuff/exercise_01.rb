words = [
  "laboratory",
  "experiment",
  "Pans Labyrinth",
  "elaborate",
  "polar bear"
]

words.each do |word|
  regexp = /lab/i
  puts word if regexp.match(word)
end
