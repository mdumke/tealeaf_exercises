# You want to create a nice interface that allows you to accurately describe the action you want your program to perform. Create a method called spray_paint that can be called on an object and will modify the color of the car.

class MyCar
  attr_accessor :speed, :color
  attr_reader :year, :model

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  # prints some basic information about the current state
  def info
    p "The #{year} #{model} is #{color} and has a speed of #{speed}."
  end

  # changes the color of the car
  def spray_paint(new_color)
    self.color = new_color
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
car.spray_paint 'blue'
car.brake
car.shut_off
