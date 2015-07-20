# coding: utf-8

# exercise 1: using select on hashes 
family = {
  uncles:   ["bob", "joe", "steve"],
  sisters:  ["jane", "jill", "beth"],
  brothers: ["frank","rob","david"],
  aunts:    ["mary","sally","susan"]
}

immediate_family = family
  .select { |f| [:sisters, :brothers].include? f }
  .values
  .flatten

p "Immediate family members are: #{immediate_family}"

