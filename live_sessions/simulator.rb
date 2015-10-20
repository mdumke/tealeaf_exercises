class Robot
  DIRECTIONS = [:north, :east, :south, :west]

  MOVE_FORWARD = {
    east:  -> (robot) { robot.x += 1},
    west:  -> (robot) { robot.x -= 1},
    north: -> (robot) { robot.y += 1}, 
    south: -> (robot) { robot.y -= 1}
  }

  attr_accessor :x, :y, :bearing

  def orient(direction)
    input_check(direction)

    self.bearing = direction  
  end 

  def coordinates
    [x, y]
  end

  def at(x, y)
    self.x = x
    self.y = y
  end
  
  def advance
    MOVE_FORWARD[bearing].call(self)
  end

  def turn_right
    turn(&:+)
  end

  def turn_left
    turn(&:-)
  end

  private

  def turn(&direction)
    index = direction.call(DIRECTIONS.index(bearing), 1)

    self.bearing = DIRECTIONS[index % DIRECTIONS.length]
  end

  def input_check(direction)
    unless DIRECTIONS.include? direction
      fail(ArgumentError, "invalid direction #{ direction }")
    end
  end
end

class Simulator
  INSTRUCTIONS = {
    L: :turn_left,
    R: :turn_right,
    A: :advance
  }

  def instructions(commands)
    commands.each_char.map { |c| INSTRUCTIONS[c.to_sym] }
  end

  def place(robot, options)
    robot.at(options[:x], options[:y])
    robot.orient(options[:direction])
  end

  def evaluate(robot, commands)
    instructions(commands).each { |instruction| robot.send(instruction) }
  end
end

