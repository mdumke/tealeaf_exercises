# Add an accessor method to your MyCar class to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.

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
car.color = 'blue'
car.brake
car.shut_off
