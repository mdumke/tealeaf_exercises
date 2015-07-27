# Create a module for the class you created in exercise 1 and include it properly.

module BasicInteractions
  def read
    p "It says here: Blah blah blah"
  end

  def recycle
    p "You have thrown me away."
  end
end

class Book
  include BasicInteractions
end

class Paper
  include BasicInteractions
end


book = Book.new
book.read

paper = Paper.new
paper.read
paper.recycle
