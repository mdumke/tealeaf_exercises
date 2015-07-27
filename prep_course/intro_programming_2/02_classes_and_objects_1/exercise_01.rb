# Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car. Create an instance variable that is set to 0 during instantiation of the object to track the current speed of the car as well. Create instance methods that allow the car to speed up, brake, and shut the car off.

class MyCar
  attr_accessor :speed
  attr_reader :year, :model, :color

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  # prints some basic information about the current state
  def info
    p "The #{year} #{model} now has a speed of #{speed}."
  end

  # increases the speed of the car by 5 units
  def speed_up
    self.speed += 5
    info
  end

  # decreases the speed by 5 units
  def brake
    self.speed -= 5
    info
  end

  # sets the speed to 0
  def shut_off
    self.speed = 0
    info
    p "The car is now shut off"
  end
end

car = MyCar.new(1928, 'green', 'Ford')
car.speed_up
car.speed_up
car.brake
car.shut_off
