class Robot
  DIRECTIONS = [:north, :east, :south, :west]

  MOVE_FORWARD = {
    east:  -> (robot) { robot.x += 1},
    west:  -> (robot) { robot.x -= 1},
    north: -> (robot) { robot.y += 1},
    south: -> (robot) { robot.y -= 1}
  }

  attr_accessor :x, :y, :dir_index

  def orient(direction)
    validate_input direction

    self.dir_index = DIRECTIONS.index(direction)
  end

  def coordinates
    [x, y]
  end

  def bearing
    DIRECTIONS[dir_index]
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
    self.dir_index = direction.call(dir_index, 1) % DIRECTIONS.length
  end

  def validate_input(direction)
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

  def place(robot, config)
    robot.at(config[:x], config[:y])
    robot.orient(config[:direction])
  end

  def evaluate(robot, commands)
    instructions(commands).each { |instruction| robot.send(instruction) }
  end
end

