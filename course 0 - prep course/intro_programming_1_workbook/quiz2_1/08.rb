# In another example we used some built-in string methods to change the case of a string. A notably missing method is something provided in Rails, but not in Ruby itself...titleize! This method in Ruby on Rails creates a string that has each word capitalized as it would be in a title.

# Write your own version of the rails titleize!

# capitalizes every word in the given string, words may be separated by dashes
def titelize(str, ignore_dashes = false)
  #base case
  if ignore_dashes
    str.split(' ').map { |word| word.capitalize }.join(' ')

  # recursive step
  else
    # make sure we ignore dashes after this one split
    str.split('-').map { |substr| titelize(substr, true) }.join('-')
  end
end

p titelize 'heiTOr viLLa-lobos'
