class Robot
  DIRECTIONS = [:north, :east, :south, :west]

  attr_accessor :bearing, :coordinates

  def orient(direction)
    fail(ArgumentError, "invalid direction #{ direction }") unless DIRECTIONS.include? direction
    self.bearing = direction  
  end 

  def at(x, y)
    self.coordinates = [x, y]
  end
  
  def advance
    case bearing
    when :north
      self.coordinates = [coordinates[0], coordinates[1] + 1]
    when :east
      self.coordinates = [coordinates[0] + 1, coordinates[1]]
    when :south
      self.coordinates = [coordinates[0], coordinates[1] - 1]
    else
      self.coordinates = [coordinates[0] - 1, coordinates[1]]
    end
  end

  def turn_right
    self.bearing = DIRECTIONS[(DIRECTIONS.index(bearing) + 1) % DIRECTIONS.length]
  end

  def turn_left
    self.bearing = DIRECTIONS[(DIRECTIONS.index(bearing) - 1) % DIRECTIONS.length]
  end
end

class Simulator
  COMMANDS = {
    L: :turn_left,
    R: :turn_right,
    A: :advance
  }

  def instructions(str)
    str.each_char.map { |c| COMMANDS[c.to_sym] }
  end

  def place(robot, options)
    robot.at(options[:x], options[:y])
    robot.orient(options[:direction])
  end

  def evaluate(robot, commands)
    instructions(commands).each { |instruction| robot.send(instruction) }
  end
end

