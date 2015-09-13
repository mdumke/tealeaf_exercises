class Robot
  attr_accessor :name

  def initialize
    @name = random_name
  end

  # assigns a new name to the robot
  def reset
    self.name = random_name
  end

  private

  # returns a string of two letters and three numbers
  def random_name
    letters = [*('a'..'z'), *('A'..'Z')].shuffle.take(2).join
    digits  = [*(0..9)].shuffle.take(3).join

    letters + digits
  end
end
