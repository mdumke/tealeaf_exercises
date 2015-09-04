# How do we create an object in Ruby? Give an example of the creation of an object.

# 1. define a class
class Book
end

class Paper
end

# 2. instantiate an object
book = Book.new
paper = Paper.new

# 3 some inspection
p book
p Book.ancestors

p paper
p Paper.ancestors
