# coding: utf-8

# exercise 6: checking for anagrams

words =  [
  'demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live',
  'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide',
  'flow', 'neon'
]

# collect anagrams as arrays within a hash
anagrams = {}

# if a word does not belong in an existing group, create a new group
words.each do |word|
  word_as_key = word.split('').sort.join('').to_sym

  if anagrams.has_key? word_as_key
    anagrams[word_as_key].push(word)
  else
    anagrams[word_as_key] = [word]
  end
end

p anagrams
